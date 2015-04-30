require 'pp'
require 'net/http'
require 'uri'
require 'socket'
require 'sys/filesystem'

class ServiceStatus
  attr_reader :name, :version, :hostname, :errors, :checks, :timestamp, :status

  def initialize(name, version, boot_time)
    @boot_time = boot_time
    @name = name
    @version = version
    @hostname = Socket.gethostname
    @checks = []
    @timestamp = Time.zone.now.strftime('%Y-%m-%d %T')
    @errors = []
  end

  def add_http_get_check(name, url)
    @checks << name
    uri = URI(url)
    begin
      res = Net::HTTP.get_response(uri)
      @errors << name unless res.is_a?(Net::HTTPSuccess)
    rescue
      @errors << name
    end
  end

  def status
    online? ? 'Online' : 'Error'
  end

  def online?
    @errors.empty?
  end

  def uptime
    total_seconds = Time.zone.now - @boot_time
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    days = total_seconds / (60 * 60 * 24)
    format('%01dd:%02d:%02d:%02d', days, hours, minutes, seconds)
  end

  def disk_usage
    format('%01d%%', (disk_used / disk_size) * 100)
  end

  def to_json(*a)
    { name: name,
      version: version,
      hostname: hostname,
      errors: errors,
      checks: checks,
      timestamp: timestamp,
      uptime: uptime,
      diskUsage: disk_usage,
      status: status }.to_json(*a)
  end

  private

  def disk_used
    disk_size - disk_available
  end

  def disk_available
    @blocks_available ||= filesystem.blocks_available.to_f
  end

  def disk_size
    @disk_size ||= filesystem.blocks.to_f
  end

  def filesystem
    @stats ||= Sys::Filesystem.stat('/')
  end
end
