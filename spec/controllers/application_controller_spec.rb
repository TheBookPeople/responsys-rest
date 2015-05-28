require 'rails_helper'

describe ApplicationController do

  controller do
    def index
      raise 'Boom!'
    end
  end

  describe 'rescuse_from'  do

    it 'json' do
      @request.env["HTTP_ACCEPT"] = "application/json"
      @request.env["CONTENT_TYPE"] = "application/json"
      get :index, format: :json

      expect(response.body).to eql "{\"error_message\":\"Boom!\"}"
    end

    it 'html' do
      begin
        get :index
      rescue => e
        exception = e
      end

      expect(exception.message).to eql 'Boom!'
    end
  end
end

