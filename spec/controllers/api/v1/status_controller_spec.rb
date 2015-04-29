require 'rails_helper'
require 'pp'
require 'socket'

describe Api::V1::StatusController, type: :controller do
  describe 'index'  do

    before :each do
      @status = instance_double("ServiceStatus")
      @json = '{"test":"data"}'
      expect(@status).to receive(:to_json) { @json }
      expect(@status).to receive(:add_http_get_check).with('Responsys API','https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
      expect(ServiceStatus).to receive(:new) { @status }
    end


    describe 'online' do

      before :each do
        expect(@status).to receive(:online?) { true }
      end

      it 'response status' do
        get :index
        expect(response.status).to equal 200
      end

      it 'response body' do
        get :index
        expect(response.body).to eql @json
      end


    end

    describe 'offline' do

      before :each do
        expect(@status).to receive(:online?) { false }
      end


      it 'response code' do
        get :index
        expect(response.status).to equal 503
      end

      it 'response body' do
        get :index
        expect(response.body).to eql @json
      end

    end


  end

end

