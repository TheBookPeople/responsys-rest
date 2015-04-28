module Api
  module V1
    class ProfileExtensionController < ApplicationController
      before_action :validate_params, only: [:create]

      def create
        response = client.merge_into_profile_extension(profile_extension, record_data, match_column, insert_on_no_match, update_on_match)
        render json: json(response)
      end

      private

      def client
        Responsys::Api::Client.new
      end

      def profile_extension
        Responsys::Api::Object::InteractObject.new(params[:folder], params[:profile_extension])
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
        params[:update_on_match] ? 'REPLACE_ALL' : 'NO_UPDATE'
      end

      def validate_params
        # rubocop:disable Lint/NonLocalExitFromIterator
        required_params.each { |param| validate_param_exists(param) && return }
        # rubocop:enable Lint/NonLocalExitFromIterator
        render_error_json(I18n.t('errors.invalid_record_data')) && return unless valid_record_data?
        render_error_json(I18n.t('errors.invalid_match_column')) && return unless valid_match_column?
      end

      def valid_match_column?
        %w(RIID CUSTOMER_ID EMAIL_ADDRESS MOBILE_NUMBER).include? match_column
      end

      def valid_record_data?
        params[:record_data].length > 0
      end

      def required_params
        [:profile_extension, :folder, :record_data,
         :match_column, :insert_on_no_match, :update_on_match]
      end
    end
  end
end
