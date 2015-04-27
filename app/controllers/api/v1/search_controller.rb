require 'responsys_api'
class Api::V1::SearchController < ApplicationController

  before_action :validate_params, only: [:create]

  def create
    response = Responsys::Api::Client.new.retrieve_list_members(list, query, response_columns, data)
    render json: json(response)
  end

  private

  def list
    Responsys::Api::Object::InteractObject.new(params[:folder], params[:list])
  end

  def query
    Responsys::Api::Object::QueryColumn.new(params[:query_column])
  end

  def data
    params[:query_data].split(",").map { |s| s.strip }
  end

  def response_columns
    params[:result_columns] ? params[:result_columns].split(",").map { |s| s.strip } : %w(RIID_ CUSTOMER_ID_ EMAIL_ADDRESS_ MOBILE_NUMBER_)
  end

  def validate_params
    required_params.each{|param| validate_param_exists(param) and return}
  end

  def required_params
    [:list, :folder, :query_column, :query_data]
  end
end
