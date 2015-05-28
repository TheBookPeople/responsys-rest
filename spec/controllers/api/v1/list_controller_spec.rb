require 'rails_helper'
require 'pp'

describe Api::V1::ListController, type: :controller do
  describe 'adding to list', :vcr do
    it 'returns 200' do
      post :create, get_json
      expect(response.status).to eq 200
    end
    it 'returns total_count of 2' do
      post :create, get_json
      pp response_json
      expect(response_json['total_count']).to eq '2'
    end

	it 'handles non-ok status' do
	  @client = instance_double("Responsys::Api::Client")
	  expect(Responsys::Api::Client).to receive(:new) { @client }
	  expect(@client).to receive(:merge_list_members) { {:status => 'not ok'} }
      post :create, get_json
      pp response_json
      expect(response_json['status']).to eq 'not ok'
	end

    it 'returns error_message of nil' do
      post :create, get_json
      pp response_json
      expect(response_json['error_message']).to eq nil
    end

    it 'returns rejected_count of 0' do
      post :create, get_json
      pp response_json
      expect(response_json['rejected_count']).to eq '0'
      expect(response_json['error_message']).to eq nil
    end

	describe 'with 150 recipients' do
		it 'returns 200' do
			data = get_json
			(2..149).each do |i|
				data[:record_data] << { 
					'EMAIL_ADDRESS_' => "foo-#{i}@test.thebookpeople.com",
					'CUSTOMER_ID_' => "CUST_ID_FOO-#{i}"
				}
			end	
			expect(data[:record_data].size).to eq 150
			post :create, data
			expect(response.status).to eq 200
			expect(response_json['total_count']).to eq '150'
			expect(response_json['rejected_count']).to eq '0'
		end
	end
	describe 'with 151 recipients' do

		it 'returns 400' do
			data = get_json
			(2..150).each do |i|
				data[:record_data] << { 
					'EMAIL_ADDRESS_' => "foo-#{i}@test.thebookpeople.com",
					'CUSTOMER_ID_' => "CUST_ID_FOO-#{i}"
				}
			end	
			expect(data[:record_data].size).to eq 151
			post :create, data
			pp response_json
			expect(response.status).to eq 400
		end
		it 'sets error_message' do
			data = get_json
			(2..150).each do |i|
				data[:record_data] << { 
					'EMAIL_ADDRESS_' => "foo-#{i}@test.thebookpeople.com",
					'CUSTOMER_ID_' => "CUST_ID_FOO-#{i}"
				}
			end	
			expect(data[:record_data].size).to eq 151
			post :create, data
			expect(response_json['error_message']).to eq 'Maximum of 150 records exceeded.'
		end
	end

#    describe 'not on list' do
#      it '200 returned' do
#        data = get_json
#        post :create, data
#        expect(response.status).to equal 200
#      end
#
#      it 'should return a recipient_id of -1' do
#        data = get_json
#        post :create, data
#        expect(response_json[1]['recipient_id']).to eq '-1'
#      end
#
#      it 'error message' do
#        data = get_json
#        post :create, data
#        expect(response_json[1]['error_message']).to eq 'Recipient Not Found'
#      end
#
#      it 'status is false' do
#        data = get_json
#        post :create, data
#        expect(response_json[1]['success']).to eq false
#      end
#    end

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
        post :create, get_json.except(:record_data)
		expect(response.status).to eq 400
        expect(response_json['error_message']).to eq "Missing 'record_data' parameter"
      end
    end
  end

  def get_json
    {
      :folder =>  "z_Stock_Alerts",#'TBP_Prog_Stock_Alert',#
      :list => 'z_Stock_Alerts_Test_List',#'Empty_Stock_Alerts_List'
	  :record_data => [
		  {
			  'EMAIL_ADDRESS_':'luke.farrar@thebookpeople.co.uk',
			  'CUSTOMER_ID_':'CUST_ID_99',
		  },
		  {
			  'EMAIL_ADDRESS_':'lukepfarrar@gmail.com',
			  'CUSTOMER_ID_':'CUST_ID_33',
		  }
	  ]
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
