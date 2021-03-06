class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from Exception do |exception|
	  if json_request? 
		  render_error_json(exception.message)
		  logger.error(exception)
	  else
	  	  fail(exception)
	  end
  end

  def json(data)
    params[:pretty] ? JSON.pretty_generate(data) : data
  end

  def validate_param_exists(param)
    render_error_json("Missing '#{param}' parameter") unless params[param]
  end

  def render_error_json(message)
  	logger.error(message)
    render(status: :bad_request, json: json_error(message))
  end

  private

  def json_request?
    request.content_type =~ /json/
  end

  def json_error(message)
    result = {
		'error_message' => message
	}
    json result
  end
end
