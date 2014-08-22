# This is a utilities class that has a variety of useful methods that can be 
# used in a variety of different cases. This is used extensively throughout 
# the ocnbot's code in order to retrieve html data from https://oc.tc

module Utility
  require 'net/https'
  require 'net/ping'

  # Retrieve html from the specified url, works with SSL web pages
  def Utility.retrieve_html(url)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.port == 443
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if url.port == 443
    path = url.path
    res = http.get(url)
  end

  # Ping a MC server using the net-ping gem and the external ping
  def Utility.ping_mcserver(ip)
    Net::Ping::External.new(ip).ping?
  end
end
