require 'rails_helper'
require 'pp'
require 'socket'

describe ServiceStatus do

  before :each do
    @version = '0.0.1'
    @hostname = Socket.gethostname
    @app_name = 'killer-app'
    @instance = ServiceStatus.new(@app_name, @version, Time.zone.now)
  end

  it 'name' do
    expect(@instance.name).to eql @app_name
  end

  it 'version' do
    expect(@instance.version).to eql @version
  end

  it 'hostname' do
    expect(@instance.hostname).to eql @hostname
  end

  it 'errors' do
    expect(@instance.errors).to eql []
  end

  it 'checks' do
    expect(@instance.checks).to eql []
  end

  it 'timestamp' do
    Timecop.freeze
    @instance = ServiceStatus.new(@app_name, @version, Time.zone.now)
    timestamp =  Time.zone.now.strftime '%Y-%m-%d %T' 
    expect(@instance.timestamp).to eql timestamp
    Timecop.return
  end

  describe "uptime" do

    it 'seconds' do
      Timecop.freeze
      @instance = ServiceStatus.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 55)
      expect(@instance.uptime).to eql '0d:00:00:55'
      Timecop.return
    end

    it 'minutes' do
      Timecop.freeze
      @instance = ServiceStatus.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 301)
      expect(@instance.uptime).to eql '0d:00:05:01'
      Timecop.return
    end

    it 'hours' do
      Timecop.freeze
      @instance = ServiceStatus.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 5000)
      expect(@instance.uptime).to eql '0d:01:23:20'
      Timecop.return
    end

    it 'days' do
      Timecop.freeze
      @instance = ServiceStatus.new(@app_name, @version, Time.now)
      Timecop.travel(Time.now + 100000)
      expect(@instance.uptime).to eql '1d:27:46:40'
      Timecop.return
    end

  end

  it 'diskUsage' do
    stats = double("stats")
    expect(stats).to receive(:blocks) { '239189165' }
    expect(stats).to receive(:blocks_available) { '106180000' }
    expect(Sys::Filesystem).to receive(:stat).with("/") { stats }
    expect(@instance.disk_usage).to eql '55%'
  end

  it 'status' do
    expect(@instance.status).to eql 'Online'
  end

  it 'to_json' do
    Timecop.freeze(Time.zone.local(2015,04,29,14,52,47))
    @instance = ServiceStatus.new(@app_name, @version, Time.zone.now)
    stats = double("stats")
    expect(stats).to receive(:blocks) { '239189165' }
    expect(stats).to receive(:blocks_available) { '106180000' }
    expect(Sys::Filesystem).to receive(:stat).with("/") { stats }
    disk_usage = '55%'
    expect(@instance.to_json).to eql "{\"name\":\"#{@app_name}\",\"version\":\"#{@version}\",\"hostname\":\"#{@hostname}\",\"errors\":[],\"checks\":[],\"timestamp\":\"2015-04-29 14:52:47\",\"uptime\":\"0d:00:00:00\",\"diskUsage\":\"#{disk_usage}\",\"status\":\"Online\"}"
    Timecop.return
  end

  describe 'add_http_get_check', :vcr do

    it 'ok' do
      @instance.add_http_get_check('Responsys API', 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
      expect(@instance.checks).to eql ['Responsys API']
      expect(@instance.errors).to eql []
    end

    it 'fail' do
      @instance.add_http_get_check('Responsys API', 'https://foobar.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl')
      expect(@instance.checks).to eql ['Responsys API']
      expect(@instance.errors).to eql ['Responsys API']
      expect(@instance.status).to eql 'Error'
    end

  end
end
