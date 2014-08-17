# This class is a cinch plugin that reads the status of the Minecraft servers
# and reports their status to the Twitch channel. 
require 'json'
require 'open-uri'

class Status 
  include Cinch::Plugin

  # What to to do when the command is executed
  match "status"
  def execute(m)
    message = get_mcstatus_string
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

end
