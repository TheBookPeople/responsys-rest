require 'rails_helper'
require 'pp'

describe Api::V1::TriggerCampaignMessageController, type: :controller do
  describe 'create', :vcr do
    it 'returns 200' do
      post :create, get_json
      expect(response.status).to eq 200
    end

    it 'returns ok' do
      post :create, get_json
	  pp response_json
      expect(response_json['success']).to eq true
    end

    it 'returns results' do
      post :create, get_json
      expect(response_json.length).to equal 3
    end

    describe 'not on list' do
      it '404 returned' do
        data = get_json
        data['to'] = 'not-on-list@foo.thebookpeople.com'
        post :create, data
        expect(response.status).to equal 404
      end

      it 'error message' do
        data = get_json
        data['to'] = 'not-on-list@foo.thebookpeople.com'
        post :create, data
		expect(response.status).to eq 404
        expect(response_json['error_message']).to eq 'Recipient Not Found'
      end

      it 'status' do
        data = get_json
        data['to'] = 'not-on-list@foo.thebookpeople.com'
        post :create, data
        expect(response_json['success']).to eq false
      end
    end

    describe 'missing param' do
      it 'list' do
        post :create, get_json.except(:list)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'list' parameter"
      end

      it 'folder' do
        post :create, get_json.except(:folder)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'folder' parameter"
      end

      it 'to' do
        post :create, get_json.except(:to)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'to' parameter"
      end

      it 'campaign' do
        post :create, get_json.except(:campaign)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'campaign' parameter"
      end
    end
  end

  def get_json
    {
      :folder =>  "z_Stock_Alerts",#'TBP_Prog_Stock_Alert',#
      :campaign => "z_TBP_Stock_Alerts",#'Stock_Alerts_Campaign'
      :list => 'z_Stock_Alerts_Test_List',#'Empty_Stock_Alerts_List'
      :to => 'luke.farrar@thebookpeople.co.uk',
      :optional_data => {
      	  PRODUCT_TITLE: 'Bob Pidgeon',
      	  AUTHOR: 'Iwan Pritchard',
      	  PRICE: '1.23',
      	  FIRST_NAME: 'Bob',
      	  SAVING: '0.77',
		  PRODUCT_PAGE_URL: 'http://www.thebookpeople.co.uk/books/NROJ',
		  PRODUCT_IMAGE_URL: 'http://images.thebookpeople.co.uk/NROJ.jpg'
	  }
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
