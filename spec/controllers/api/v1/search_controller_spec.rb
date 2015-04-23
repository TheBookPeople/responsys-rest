require 'rails_helper'

describe Api::V1::SearchController do

  describe "create", :vcr do

    it "returns 200" do
      post :create, get_json
      expect(response.status).to equal 200
    end

  end


  def get_json
    {
        :list => 'Stock Alert',
        :folder =>  "TBP_Prog_Stock_Alert",
        :query_column => "EMAIL_ADDRESS",
        :query_data =>  "nigel.vivian@thebookpeople.co.uk, iwan.pritchard@thebookpeople.co.uk",
        :result_columns =>  "PRODUCT_TITLE, FIRST_NAME, LAST_NAME"
    }
  end
end