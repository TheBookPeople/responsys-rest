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
      expect(response_json[0]['success']).to eq true
    end

    it 'returns results as an array of objects' do
      post :create, get_json
      expect(response_json.length).to equal 2
      expect(response_json[0].length).to equal 3
      expect(response_json[1].length).to equal 3
    end

	describe 'with 150 recipients' do
		it 'returns 200' do
			data = get_json
			(2..149).each { |i| data[:recipients] << { email:"foo-#{i}@test.thebookpeople.com" }}
			expect(data[:recipients].size).to eq 150
			post :create, data
			expect(response.status).to eq 200
		end
	end
	describe 'with 151 recipients' do

		it 'returns 400' do
			data = get_json
			(2..150).each { |i| data[:recipients] << {email:"foo-#{i}@test.thebookpeople.com"}}
			expect(data[:recipients].size).to eq 151
			post :create, data
			expect(response.status).to eq 400
		end
		it 'sets error_message' do
			data = get_json
			(2..150).each { |i| data[:recipients] << {email:"foo-#{i}@test.thebookpeople.com"}}
			post :create, data
			expect(response_json['error_message']).to eq 'Maxium of 150 recipients'
		end
	end

    describe 'not on list' do
      it '200 returned' do
        data = get_json
        post :create, data
        expect(response.status).to equal 200
      end

      it 'should return a recipient_id of -1' do
        data = get_json
        post :create, data
        expect(response_json[1]['recipient_id']).to eq '-1'
      end

      it 'error message' do
        data = get_json
        post :create, data
        expect(response_json[1]['error_message']).to eq 'Recipient Not Found'
      end

      it 'status is false' do
        data = get_json
        post :create, data
        expect(response_json[1]['success']).to eq false
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

	  it 'fails when missing recipients' do
        post :create, get_json.except(:recipients)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'recipients' parameter"
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
	  :recipients => [
		  {
			  :email => 'luke.farrar@thebookpeople.co.uk',
			  :optional_data => {
				  PRODUCT_TITLE: 'Bob Pidgeon',
				  AUTHOR: 'Iwan Pritchard',
				  PRICE: '1.23',
				  FIRST_NAME: 'Bob',
				  SAVING: '0.77',
				  PRODUCT_PAGE_URL: 'http://www.thebookpeople.co.uk/books/NROJ',
				  PRODUCT_IMAGE_URL: 'http://images.thebookpeople.co.uk/NROJ.jpg'
			  }
		  },
		  {
			  :email => 'no-on-list@fake.thebookpeople.com',
			  :optional_data => {
				  PRODUCT_TITLE: 'Not Real',
				  AUTHOR: 'Iwan Pritchard',
				  PRICE: '1.23',
				  FIRST_NAME: 'Not',
				  SAVING: '0.77',
				  PRODUCT_PAGE_URL: 'http://www.thebookpeople.co.uk/books/NROJ',
				  PRODUCT_IMAGE_URL: 'http://images.thebookpeople.co.uk/NROJ.jpg'
			  }

		  }
	  ]
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
