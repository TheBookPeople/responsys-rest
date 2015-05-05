require 'rails_helper'
require 'pp'

describe Api::V1::SearchController, type: :controller do
  describe 'create', :vcr do
    it 'returns 200' do
      post :create, get_json
      expect(response.status).to equal 200
    end

    it 'returns ok' do
      post :create, get_json
      expect(response_json['status']).to eq 'ok'
    end

    it 'returns results' do
      post :create, get_json
      expect(response_json['data'].length).to equal 3
    end

    it 'supports custom results fields' do
      post :create, get_json
      first_result = { 'EMAIL_DELIVERABILITY_STATUS_' => 'D',
                       'EMAIL_MD5_HASH_' => '111d68d06e2d317b5a59c2c6c5bad808'}
      expect(response_json['data'][0] == first_result).to equal true
    end

    it 'has default result colums' do
      post :create, get_json.except(:result_columns)
      first_result = { 'RIID_' => '449436402',
                       'CUSTOMER_ID_' => '1',
                       'EMAIL_ADDRESS_' => 'user1@example.com',
                       'MOBILE_NUMBER_' => nil }
      expect(response_json['data'][0] == first_result).to equal true
    end

    describe 'no results' do
      it '200 returned' do
        data = get_json
        data['query_data'] = 'me@example.com'
        post :create, data
        expect(response.status).to equal 200
      end

      it 'error message' do
        data = get_json
        data['query_data'] = 'me@example.com'
        post :create, data
        expect(response_json['error']['message']).to eq 'No records found in the list for given ids'
      end

      it 'status' do
        data = get_json
        data['query_data'] = 'me@example.com'
        post :create, data
        expect(response_json['status']).to eq 'failure'
      end
    end

    describe 'missing param' do
      it 'list' do
        post :create, get_json.except(:list)
        expect(response_json['error']['message']).to eq 'Missing list parameter'
      end

      it 'folder' do
        post :create, get_json.except(:folder)
        expect(response_json['error']['message']).to eq 'Missing folder parameter'
      end

      it 'query_column' do
        post :create, get_json.except(:query_column)
        expect(response_json['error']['message']).to eq 'Missing query_column parameter'
      end

      it 'query_data' do
        post :create, get_json.except(:query_data)
        expect(response_json['error']['message']).to eq 'Missing query_data parameter'
      end
    end
  end

  def get_json
    {
      :list => 'z_Notifications_Email_list',
      :folder =>  "z_Notifications",
      :query_column => "EMAIL_ADDRESS",
      :query_data =>  ["user1@example.com", "user2@example.com"],
      :result_columns =>  "EMAIL_DELIVERABILITY_STATUS_, EMAIL_MD5_HASH_"
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
