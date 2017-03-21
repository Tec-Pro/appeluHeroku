class Api::V1::CustomerServiceDaysController < ApplicationController
	before_action :authenticate, except: [:index,:show]
	before_action :set_customerServiceDay, only: [ :show,:update,:destroy ]
	before_action :set_business
	before_action(only: [:update,:destroy,:create]) { |controlador| controlador.authenticate_owner(@business.user) }


	#GET /businesses/:business_id/CustomerServiceDays
	def index
		@customerServiceDays = @business.customerServiceDays
	end

	#GET /businesses/1/customerServiceDays/2
	def show
		render template: "api/v1/customerServiceDays/show"
	end


	#POST /businesses/1/customerServiceDays
	def create
		if !CustomerServiceDay::DAYS_OF_THE_WEEK.include? params[:day]
			render json: { error: "incorrect day"}, status: :unprocessable_entity
			return
		end
		@customerServiceDay = @business.customerServiceDays.new(customerServiceDay_params)
		if @customerServiceDay.save
			render template: "api/v1/customerServiceDays/show"
		else
			render json: { error: @customerServiceDay.errors }, status: :unprocessable_entity
		end
	end

	#PATCH PUT /businesses/1/customerServiceDays/1
	def update
		if @customerServiceDay.update(customerServiceDay_params)
			render template: "api/v1/customerServiceDays/show"
		else
			render json: { error: @customerServiceDay.errors }, status: :unprocessable_entity
		end
	end

	#DELETE /businesses/1/customerServiceDays/1
	def destroy
		@customerServiceDay.destroy
		head :ok
	end


	private

	def customerServiceDay_params
		params.permit(:day,:openingTime,:closingTime,:openingTime2,:closingTime2) 
	end


	def set_business
		@business = Business.find(params[:business_id])
	end

	def set_customerServiceDay
		@customerServiceDay = CustomerServiceDay.find(params[:id])
	end	

end