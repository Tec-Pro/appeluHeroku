class Api::V1::ShiftsController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:update]
	before_action :authenticate, except: [:index,:show]
	before_action :set_shift, only: [:update,:destroy]
	before_action :set_service, only: [:create]
	before_action :set_user, only: [:create,:update]
	before_action(only: [:destroy]) { |controlador| controlador.authenticate_owner(@shift.user) } #TODO agar eidcion para el dueño

	def index

		if params[:user_id]
			@shifts = Shift.where("user_id = #{params[:user_id]}")
			return 
		end

		if params[:service_id]
			@shifts = Shift.where("service_id = #{params[:service_id]}")
			return 
		end

		render json: { error: "no encontramos parametros"}	
	end
	#POST /shifts
	def create

		@shift = Shift.new(shift_params)
		if @shift.save
			print "dia de la reservaaaa: #{(@shift.start_time+0.days).strftime("%A") }"
			render template: "api/v1/shifts/show"
		else
			render json: { error: @shift.errors }, status: :unprocessable_entity
		end
	end

	#PUT shifts/1
	def update
		puts "hola: #{@shift}"
		if @shift.update(shift_params)
			render template: "api/v1/shifts/show"
		else
			render json: { error: @shift.errors }, status: :unprocessable_entity
		end
	end

	#DELETE /shifts/1
	def destroy
		@shift.destroy
		head :ok
	end

	private

	def shift_params
		params.permit(:comment,:start_time,:end_time,:status,:user_id,:service_id)
	end

	def set_shift
		@shift = Shift.find(params[:id])
	end	

	def set_service
		@service = Service.find(params[:service_id])
	end	

	def set_user
		@user = User.find(params[:user_id])
	end	


end