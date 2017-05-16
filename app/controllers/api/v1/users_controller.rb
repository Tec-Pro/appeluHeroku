require 'bcrypt'

class Api::V1::UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:login, :create, :update]
	before_action :authenticate, only: [:update, :destroy]
	before_action :set_user, only: [:show]
	# POST /users
	def create
		#params = { auth:{ provider: 'facebook', uid:'12adsashd71' } }

		if params[:password]
			@user = User.new(user_params)
			@user.save!
			@token = @user.tokens.create

			response.headers["X-AUTH-TOKEN"] = @token.token
			render "api/v1/users/show"
		elsif params[:auth]
			@user = User.from_omniauth(params[:auth])
			@token = @user.tokens.create

			response.headers["X-AUTH-TOKEN"] = @token.token
			render "api/v1/users/show"	
		
		else
			render json: { error: "No encontramos parámetros" }
		end	
	end

	def update
		@current_user.update(user_update_params)
		render "api/v1/users/show"		
	end

	#GET /users/1
	def show		
	end

	def destroy
		@user = User.find(params[:id])
		if @current_user.role == "ADMIN" or @current_user == @user
			@user.enable = false
			@user.save!
			render json: { message: "Usuario eliminado"  }
		else
			error!("No tiene permisos para realizar esta accion", :unauthorized)
		end		
	end	


	#TODO - Only accessible for admin users
	#TODO - ¿Mostrar solo los usuarios activos?
	def index
		#if @current_user.role = "ADMIN"
			@users = User.where(enable: true)
		#else
		#	error!("No tiene permisos para realizar esta accion", :unauthorized)
		#end	
	end


def login
	if !request.headers["X-AUTH-TOKEN"].nil?
		authenticate
	else		
		@user = User.find_by_email(params[:email])
		if @user.password == params[:password]
			@current_user = @user
			@token = Token.where(user_id: @user.id).first
			if !@token.nil? or !@token.is_valid?
				@user.tokens.create
			end	
			response.headers["X-AUTH-TOKEN"] = @token.token
	  	else
			error!("Tu contrseña es inválida", :unauthorized)
	  	end
	end
	render "api/v1/users/show"  	
end

def shifts
	@current_user.shifts
end

def recovery
	@user = User.find_by_email(params[:email])
	if @user.present?
	  random_password = Array.new(10).map { (65 + rand(58)).chr }.join
	  @user.password = random_password
	  @user.save!
	  Mailer.create_and_deliver_password_change(@user, random_password)
	  render json: { message: "Su nueva contrseña ha sido enviada a su email" 	, status: :ok }
	else
			error!("Usuario inexistente", :not_found)  
	end 
end

	private

		def user_params
			params.permit(:email,:password,:phone,:role) 
		end

		def user_update_params
			params.permit(:password,:phone,:role,:enable) 
		end

		def set_user
			@user = User.find(params[:id])
		end

end