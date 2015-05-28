require 'responsys_api'
module Api
  module V1
    class ListController < ApplicationController
      before_action :validate_params, only: [:create]

      def create
        list = Responsys::Api::Object::InteractObject.new(params[:folder], params[:list])
        record_data = Responsys::Api::Object::RecordData.new(params[:record_data])
        if params[:record_data].size > 150
          render(status: :bad_request, json: { 'error_message': 'Maximum of 150 records exceeded.' })
        else
          response = Responsys::Api::Client.new.merge_list_members(list, record_data, Responsys::Api::Object::ListMergeRule.new(insertOnNoMatch: true))

          if response[:status] == 'ok'
            render json: json(response[:data][0][:result])
          else
            render json: json(response)
          end
        end
    end

      private

      def validate_params
        # rubocop:disable Lint/NonLocalExitFromIterator
        required_params.each { |param| validate_param_exists(param) && return }
        # rubocop:enable Lint/NonLocalExitFromIterator
      end

      def required_params
        [:list, :folder, :record_data]
      end
  end
  end
end
