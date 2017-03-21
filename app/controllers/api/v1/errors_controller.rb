class Api::V1::ErrorsController < ActionController::Base
  def not_found
    render :json => {:error => "not-found"}.to_json, :status => 404
  end

  def exception
    render :json => {:error => "internal-server-error"}.to_json, :status => 500
  end

  def Unprocessable
  	 render :json => {:error => "Unprocessable Entity"}.to_json, :status => 422
  end	
end

