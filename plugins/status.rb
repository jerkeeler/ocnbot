# This class is a cinch plugin that reads the status of the Minecraft servers
# and reports their status to the Twitch channel. 

require 'json'
require 'open-uri'
require_relative 'utility'

class Status 
  include Cinch::Plugin
  include Utility

  # What to to do when the command is executed
  match "status"
  def execute(m)
    message = get_mcstatus_string
    m.twitch(message)

    sleep(1);
    
    message = get_ocnstatus_string
    m.twitch(message)
  end

  # Retrieve the JSON string from the Mojang support site, parse it and return
  # a string representation of the mc server status
  def get_mcstatus_string
    # Retrieve the JSON array
    json_array = JSON.parse(open("http://status.mojang.com/check").read)
    status_hash = Hash.new

    # Add all hashes to one hash for easy access
    json_array.each do |element|
      status_hash.merge!(element)
    end

    # Check session status
    sessionstatus = "OK"
    if (status_hash["session.minecraft.net"] != "green" || status_hash["sessionserver.mojang.com"] != "green")
      sessionstatus = "DIFFICULTIES"
    end

    # Check login status
    loginstatus = "OK"
    if (status_hash["auth.mojang.com"] != "green" || status_hash["account.mojang.com"] != "green" || status_hash["authserver.mojang.com"] != "green")
      loginstatus = "DIFFICULTIES"
    end

    "MCStatus : Sessions - #{sessionstatus}, Logins - #{loginstatus}"
  end

  # Ping the US, EU, and TM OCN servers and check for website response
  def get_ocnstatus_string
    # Ping us servers
    us_ping = Utility::ping_mcserver("us.oc.tc")
    us_ping ? us_status = "UP" : us_status = "DOWN"

    # Ping eu servers
    eu_ping = Utility::ping_mcserver("eu.oc.tc")
    eu_ping ? eu_status = "UP" : eu_status = "DOWN"

    # Ping tournament servers
    tm_ping = Utility::ping_mcserver("tm.oc.tc")
    tm_ping ? tm_status = "UP" : tm_status = "DOWN"

    # Check OCN website status
    res = Utility::retrieve_html("https://oc.tc/")
    case res
    when Net::HTTPSuccess
      website_status = "UP"
    else
      website_status = "DOWN"
    end

    "OCNStatus : US - #{us_status}, EU - #{eu_status}, Tournament - #{tm_status}, Website - #{website_status}"
  end
end
