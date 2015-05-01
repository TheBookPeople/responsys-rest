class HelpController < ApplicationController
  def index
    @version =  Rails.configuration.app_version
  end
end
