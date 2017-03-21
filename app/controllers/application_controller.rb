class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

 # CUSTOM EXCEPTION HANDLING
  rescue_from StandardError do |e|
    error(e)
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  protected

  def error(e)
    #render :template => "#{Rails::root}/public/404.html"
    if env["ORIGINAL_FULLPATH"] =~ /^\/api/
    error_info = {
      :error => "internal-server-error",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    render :json => error_info.to_json, :status => 500
    else
      render :text => "500 Internal Server Error", :status => 500 # You can render your own template here
      raise e
    end
  end


def authenticate
  	token_str = request.headers["X-AUTH-TOKEN"]
  	@token = Token.find_by(token: token_str)
    
  	if @token.nil? or not @token.is_valid? 
      error!("Tu token es inválido", :unauthorized)
  	else
  		@current_user = @token.user
      @user = @current_user
  	end
end

def error!(message,status)
    @errors = message
    response.status = status
    render template: "api/v1/errors"
end

def error_array!(array,status)
    @errors = @errors + array
    response.status = status
    render "api/v1/errors"
  end

  def authenticate_owner(owner)
    if owner != @current_user
      error!("No tienes autorizado editar este recurso", :unauthorized)
    end
  end

end

#dcedcc7531cf05332840d2eccfa241a4