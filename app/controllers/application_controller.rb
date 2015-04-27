class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def json(data)
    params[:pretty] ? JSON.pretty_generate(data) : data
  end


  def validate_param_exists(param)
    render(:status => :bad_request, :json => json_error("Missing #{param} parameter")) unless params.has_key?(param)
  end

  def json_error(message)
    {"status"=>"failure",
     "error"=> {
      "message"=>message}
    }
  end
end
