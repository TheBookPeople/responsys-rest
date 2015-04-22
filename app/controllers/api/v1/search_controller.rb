require 'responsys_api'
require 'pp'
module Api
  module V1
    class SearchController < ApplicationController

      def create
        response = Responsys::Api::Client.new.retrieve_list_members(list, query, response_columns, data)
        render json: json(response)
      end

      private

      def list
        list_name = params[:list]
        folder_name = params[:folder]
        Responsys::Api::Object::InteractObject.new(folder_name, list_name)
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

    end
  end
end
