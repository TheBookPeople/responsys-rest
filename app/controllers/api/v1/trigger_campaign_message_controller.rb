require 'responsys_api'
module Api
  module V1
    class TriggerCampaignMessageController < ApplicationController
      before_action :validate_params, only: [:create]

      def create
		  list = Responsys::Api::Object::InteractObject.new(params[:folder], params[:list])
		  campaign = Responsys::Api::Object::InteractObject.new(params[:folder], params[:campaign])
		  recipient = Responsys::Api::Object::Recipient.new(emailAddress: params[:to], listName: list)
		  recipientData = Responsys::Api::Object::RecipientData.new(recipient)
		  params[:optional_data].each do |k,v|
			  recipientData.optional_data << Responsys::Api::Object::OptionalData.new(k,v)
		  end
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('PRODUCT_TITLE','Booking for Cooks')	
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('AUTHOR','W. Griffiths')
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('PRICE','123.45')
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('FIRST_NAME','Boo')
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('PRODUCT_PAGE_URL',"http://www.thebookpeople.co.uk/webapp/wcs/stores/servlet/qs_product_tbp?productId=536903&storeId=10001&catalogId=10051&langId=100")
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('SAVING','0.55')
#		  recipientData.optional_data << Responsys::Api::Object::OptionalData.new('PRODUCT_IMAGE_URL',"http://tbpstatic.storage.googleapis.com/2/books/large/CFGU.jpg")
		  response = Responsys::Api::Client.new.trigger_message(campaign, [recipientData])
		  if (response[:status] == 'ok')
			  result = response[:data][0][:result]
			  if (result[:success])
				  render(json: json(result))
			  else
			  	  status = 500
				  status = 404 if result[:recipient_id] == '-1'
				  render(status: status, json: json(result))
			  end
		  else
			  response[:error][:success] = false
			  render(status: 500, json: json(response[:error]))
		  end
	  end

	  private

      def validate_params
        # rubocop:disable Lint/NonLocalExitFromIterator
        required_params.each { |param| validate_param_exists(param) && return }
        # rubocop:enable Lint/NonLocalExitFromIterator
      end

      def required_params
        [:list, :folder, :campaign, :optional_data, :to]
      end

	end
  end
end
