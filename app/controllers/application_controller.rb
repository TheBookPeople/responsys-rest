class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def json(data)
    params[:pretty] ? JSON.pretty_generate(data) : data
  end

  def validate_param_exists(param)
    render_error_json("Missing #{param} parameter") unless params.key?(param)
  end

  def render_error_json(message)
    render(status: :bad_request, json: json_error(message))
  end

  def json_error(message)
    { 'status' => 'failure',
      'error' => {
        'message' => message }
    }
  end
end
