class Api::V1::BusinessesController < ApplicationController
	
	before_action :authenticate, only: [:create,:update,:destroy]
	before_action :set_business, only: [ :show,:update,:destroy ]
	before_action(only: [:update,:destroy]) { |controlador| controlador.authenticate_owner(@business.user) }
	

	def index
		if params[:user_id]
			@businesses = Business.where("user_id = #{params[:user_id]}")
		else
			render json: { error: "no encontramos parametros"  }	
		end
	end

	def show		
	end

	def create
		if (@current_user.role == "OWNER")
			@business = @current_user.businesses.new(business_params)
			if @business.save
				render "api/v1/businesses/show"
			else
				error_array!(@business.errors.full_messages,:unprocessable_entity)
			end
		else
			render json: { error: @business.errors }, status: :unauthorized
		end	
	end

	def update
		@business.update(business_params)
		render "api/v1/businesses/show"		
	end

	def destroy		
		@business.destroy
		render json: { message: "Negocio eliminado"  }		
	end

	private

	def set_business
		@business = Business.find(params[:id])
	end

	def business_params
		params.permit(:name,:enable)
	end

end