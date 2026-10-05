require 'net/http'
require 'uri'

class AddIpMetaToSessionJob < ApplicationJob
  queue_as :low_priority

  def perform(session, ip)
    @ip = ip
    
    session.update!(meta.to_h)
  end

  private

  attr_accessor :ip

  def meta
    data = OpenStruct.new

    data.ip = @ip

    return data if ip.nil? || api_key.nil? || ip == '127.0.0.1'

    t1 = Time.now.utc
    r = response
    t2 = Time.now.utc
    ms = (t2 - t1) * 1000

    data.ip_response_code = r.code
    data.ip_response_body = r.body if r.code != '200'
    data.ip_request_duration = ms

    return data if r.code != '200'

    json = JSON.parse(r.body)

    data.ip_country_id = json['country_code2']
    data.ip_timezone = json['time_zone']['name']
    data.ip_isp = json['isp']

    data
  end

  def response
    Net::HTTP.get_response(uri)
  end

  def uri
    URI.parse("https://api.ipgeolocation.io/ipgeo?apiKey=#{api_key}&ip=#{ip}")
  end

  def api_key
    Rails.application.credentials.ip_geo_api_key
  end
end
