require 'rails_helper'
require 'pp'

describe Api::V1::ProfileExtensionController, type: :controller do
  describe 'create', :vcr do
    describe 'ok' do
      it 'returns 200' do
        post :create, get_json
        expect(response.status).to equal 200
      end

      it 'status' do
        post :create, get_json
        expect(response_json['status']).to eql 'ok'
      end

      it 'recipient_id' do
        post :create, get_json
        expect(response_json['result']['recipient_id']).not_to be_nil
      end

      it 'error' do
        post :create, get_json
        expect(response_json['result']['error']).to be_nil
      end
    end

    describe 'match column' do
      it 'EMAIL_ADDDRESS' do
        data = get_json
        data[:match_column] = 'EMAIL_ADDRESS'
        post :create, data
        expect(response_json['error']).to be_nil
      end

      it 'RIID' do
        data = get_json
        data[:match_column] = 'RIID'
        post :create, data
        expect(response_json['error']).to be_nil
      end

      it 'CUSTOMER_ID' do
        data = get_json
        data[:match_column] = 'CUSTOMER_ID'
        post :create, data
        expect(response_json['error']).to be_nil
      end

      it 'MOBILE_NUMBER' do
        data = get_json
        data[:match_column] = 'MOBILE_NUMBER'
        post :create, data
        expect(response_json['error']).to be_nil
      end

      it 'EMAIL_PERMISSION_REASON' do
        data = get_json
        data[:match_column] = 'EMAIL_PERMISSION_REASON'
        post :create, data
        expect(response_json['error']['message']).to eql 'Invalid value for match_column must one of the following. RIID, CUSTOMER_ID, EMAIL_ADDRESS or MOBILE_NUMBER'
      end
    end

    describe 'missing param' do
      it 'profile_extension' do
        post :create, get_json.except(:profile_extension)
        expect(response_json['error']['message']).to eq 'Missing profile_extension parameter'
      end

      it 'folder' do
        post :create, get_json.except(:folder)
        expect(response_json['error']['message']).to eq 'Missing folder parameter'
      end

      it 'record_data' do
        post :create, get_json.except(:record_data)
        expect(response_json['error']['message']).to eq 'Missing record_data parameter'
      end

      it 'record_data is has one entry' do
        data = get_json
        data[:record_data] = []
        post :create, data
        expect(response_json['error']['message']).to eq 'Invalid record_data must have at least one record'
      end

      it 'match_column' do
        post :create, get_json.except(:match_column)
        expect(response_json['error']['message']).to eq 'Missing match_column parameter'
      end

      it 'insert_on_no_match' do
        post :create, get_json.except(:insert_on_no_match)
        expect(response_json['error']['message']).to eq 'Missing insert_on_no_match parameter'
      end

      it 'update_on_match' do
        post :create, get_json.except(:update_on_match)
        expect(response_json['error']['message']).to eq 'Missing update_on_match parameter'
      end
    end
  end

  def get_json
    {
      profile_extension: 'CategoryPreferences',
      folder: 'z_Notifications',
      record_data: [{ EMAIL_ADDRESS_: 'user1@example.com',
                      CATEGORY_1: 'Childrens',
                      PREFERENCE_1: 'LIKE' }
                   ],
      match_column: 'EMAIL_ADDRESS',
      insert_on_no_match: true,
      update_on_match: true
    }
  end

  def response_json
    JSON.parse(response.body)
  end
end
