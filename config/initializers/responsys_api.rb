require 'responsys_api'

config_file = File.join(Rails.root, 'config', 'secrets.yml')
fail "#{config_file} is missing!" unless File.exist? config_file

fail 'responsys section missing from secrets.yml' if Rails.application.secrets.responsys.nil?
fail 'responsys username not set' if Rails.application.secrets.responsys['username'].nil?
fail 'responsys password not set' if Rails.application.secrets.responsys['password'].nil?

responsys = Rails.application.secrets.responsys

Responsys.configure do |config|
  config.settings = {
    username: responsys['username'],
    password: responsys['password'],
    wsdl: 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl',
    debug: responsys['debug'] || false,
    ssl_version: :TLSv1
  }
end
