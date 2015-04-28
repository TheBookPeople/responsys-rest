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

    it 'returns 9 results' do
      post :create, get_json
      expect(response_json['data'].length).to equal 9
    end

    it 'supports custom results fields' do
      post :create, get_json
      first_result = { 'PRODUCT_TITLE' => 'Simply Italian',
                       'FIRST_NAME' => 'Iwan',
                       'LAST_NAME' => 'Pritchard' }
      expect(response_json['data'][0] == first_result).to equal true
    end

    it 'has default result colums' do
      post :create, get_json.except(:result_columns)
      first_result = { 'RIID_' => '418390408',
                       'CUSTOMER_ID_' => nil,
                       'EMAIL_ADDRESS_' => 'iwan.pritchard@thebookpeople.co.uk',
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
      list: 'Stock Alert',
      folder: 'TBP_Prog_Stock_Alert',
      query_column: 'EMAIL_ADDRESS',
      query_data: 'nigel.vivian@thebookpeople.co.uk, iwan.pritchard@thebookpeople.co.uk',
      result_columns: 'PRODUCT_TITLE, FIRST_NAME, LAST_NAME'
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
