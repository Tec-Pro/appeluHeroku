class Api::V1::ServicesController < ApplicationController
	before_action :authenticate, except: [:index,:show]
	before_action :set_service, only: [ :show,:update,:destroy ]
	before_action :set_business
	before_action(only: [:update,:destroy,:create]) { |controlador| controlador.authenticate_owner(@business.user) }



	def indexAll
		@services = Service.all
	end

	#GET /businesses/:business_id/services
	def index
		@services = @business.services
	end

	#GET /businesses/1/services/2
	def show
	end

	#POST /businesses/1/services
	def create
		@service = @business.services.new(service_params)

		if @service.save

			create_shifts()
			render template: "api/v1/services/show"

		else
			render json: { error: @service.errors }, status: :unprocessable_entity
		end
	end

	#PATCH PUT /businesses/1/services/1
	def update
		if @service.update(service_params)
			render template: "api/v1/services/show"
		else
			render json: { error: @service.errors }, status: :unprocessable_entity
		end
	end

	#DELETE /businesses/1/services/1
	def destroy
		@service.destroy
		head :ok
	end


	private

	def create_shifts()

		customerServiceDays = @business.customerServiceDays.to_a
		for i in 0..30
			customerServiceDays.each{ |x|

				if x.day == (@service.created_at+i.days).strftime("%A").upcase

					openingTime = x.openingTime

					while openingTime < x.closingTime do

						shiftStartTime = "#{(@service.created_at+i.days).strftime("%Y%m%d")}T#{openingTime.strftime("%H%M%S")}+0000"
						
						d = DateTime.iso8601(shiftStartTime)
						
						@shift = Shift.create(	comment:"",
										user_id: nil,
										service_id: @service.id,
										start_time: d,
										end_time: d + @service.duration.minutes )
						if @shift.save
							puts "turno. comienza: #{shiftStartTime}, dia: #{x.day}"
						end 
						openingTime = openingTime + @service.duration.minutes
					end

					openingTime2 = x.openingTime2

					while openingTime2 < x.closingTime2 do

						shiftStartTime = "#{(@service.created_at+i.days).strftime("%Y%m%d")}T#{openingTime2.strftime("%H%M%S")}+0000"
						
						d = DateTime.iso8601(shiftStartTime)
						
						@shift = Shift.create(	comment:"",
										user_id: nil,
										service_id: @service.id,
										start_time: d,
										end_time: d + @service.duration.minutes )
						if @shift.save
							puts "turno. comienza: #{shiftStartTime}, dia: #{x.day}"
						end 
						openingTime2 = openingTime2 + @service.duration.minutes
					end

				end

			}
		end
	end

	def service_params
		params.permit(:name,:duration,:enable) 
	end

	def set_business
		@business = Business.find(params[:business_id])
	end

	def set_question
		@service = Service.find(params[:id])
	end	

end