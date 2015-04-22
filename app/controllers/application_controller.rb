class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def json(data)
    params[:pretty] ? JSON.pretty_generate(data) : data
  end
end
