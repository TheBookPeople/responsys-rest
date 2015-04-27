class Api::V1::ProfileExtensionController < ApplicationController

  before_action :validate_params, only: [:create]

  def create
    response = Responsys::Api::Client.new.merge_into_profile_extension(profile_extension, record_data, match_column, insert_on_no_match, update_on_match)
    render json: json(response)
  end

  private

  def profile_extension
    Responsys::Api::Object::InteractObject.new(params[:folder],params[:profile_extension])
  end

  def record_data
    Responsys::Api::Object::RecordData.new(params[:record_data])
  end

  def match_column
    params[:match_column]
  end

  def insert_on_no_match
    params[:insert_on_no_match]
  end

  def update_on_match
    params[:update_on_match]? 'REPLACE_ALL' : 'NO_UPDATE'
  end

  def validate_params
    required_params.each{|param| validate_param_exists(param) and return}
    render(:status => :bad_request, :json => json_error("Invalid record_data must have at least one record")) unless params[:record_data].length > 0
  end

  def required_params
    [:profile_extension, :folder, :record_data, 
     :match_column, :insert_on_no_match, :update_on_match]
  end
end
