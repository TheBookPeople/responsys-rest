require 'responsys_api'

config_file = File.join(Rails.root,'config','secrets.yml')
raise "#{config_file} is missing!" unless File.exists? config_file

raise "responsys section missing from secrets.yml" if Rails.application.secrets.responsys.nil?

responsys = Rails.application.secrets.responsys

Responsys.configure do |config|
  config.settings = {
      username: responsys['username'],
      password: responsys['password'],
      wsdl: "https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl",
      debug: responsys['debug'] || false,
      ssl_version: :TLSv1
  }
end