require 'responsys_api'
module Api
  module V1
    class SearchController < ApplicationController
      before_action :validate_params, only: [:create]

      def create
        response = Responsys::Api::Client.new.retrieve_list_members(list, query, result_columns, data)
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
        params[:query_data]
      end

      def result_columns
        params[:result_columns] ? params[:result_columns].split(',').map(&:strip) : default_result_columns
      end

      def default_result_columns
        %w(RIID_ CUSTOMER_ID_ EMAIL_ADDRESS_ MOBILE_NUMBER_)
      end

      def validate_params
        # rubocop:disable Lint/NonLocalExitFromIterator
        required_params.each { |param| validate_param_exists(param) && return }
        # rubocop:enable Lint/NonLocalExitFromIterator
      end

      def required_params
        [:list, :folder, :query_column, :query_data]
      end
    end
  end
end
