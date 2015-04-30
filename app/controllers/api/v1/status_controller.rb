require 'pp'
require 'service_status'

module Api
  module V1
    class StatusController < ApplicationController
      def index
        service_status.add_http_get_check('Responsys API', 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
        status = service_status.online? ? :ok : :service_unavailable
        render(status: status, json: json(service_status))
      end

      private

      def service_status
        @service_status ||= ServiceStatus.new(app_name, app_version, boot_time)
      end

      def boot_time
        Rails.configuration.boot_time
      end

      def app_version
        Rails.configuration.app_version
      end

      def app_name
        'responsys-rest'
      end
    end
  end
end
