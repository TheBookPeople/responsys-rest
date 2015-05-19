require 'responsys_api'
module Api
  module V1
    class TriggerCampaignMessageController < ApplicationController
      before_action :validate_params, only: [:create]

      def create
		  list = Responsys::Api::Object::InteractObject.new(params[:folder], params[:list])
		  campaign = Responsys::Api::Object::InteractObject.new(params[:folder], params[:campaign])
		  
		  recipients = []

		  if params[:recipients].size > 150 
			  logger.error "recipients size = #{params[:recipients].size}"
			  render(status: :bad_request, json: json({error_message: 'Maxium of 150 recipients'}))	
			  return
		  end

		  params[:recipients].each do |r|
			  recipient_data = Responsys::Api::Object::RecipientData.new(Responsys::Api::Object::Recipient.new(emailAddress: r[:email], listName: list))
			  r[:optional_data].each do |k,v|
				  recipient_data.optional_data << Responsys::Api::Object::OptionalData.new(k,v)
			  end if r[:optional_data]
			  recipients << recipient_data
		  end
		  
		  response = Responsys::Api::Client.new.trigger_message(campaign, recipients)
		  if (response[:status] == 'ok')
			  render(json: json(response[:result]))
		  else
			  render(status: 500, json: json({error_code: response[:error][:code], error_message: response[:error][:message]}))
		  end
	  end

	  private

      def validate_params
        # rubocop:disable Lint/NonLocalExitFromIterator
        required_params.each { |param| validate_param_exists(param) && return }
        # rubocop:enable Lint/NonLocalExitFromIterator
      end

      def required_params
        [:list, :folder, :campaign, :recipients]
      end

	end
  end
end
