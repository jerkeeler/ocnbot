# This plugin's purpose is to display player stats from https://oc.tc when the 
# command !player <name> is given. The stats format should be displayed like 
# "PlayerName: Kills - 11, Deaths - 11, KD - 1, KK - 2, Wools - 1, Cores - 1, Monuments - 1, Playtime - 1 hour"

require 'nokogiri'
require_relative 'utilities'

class Player
  include Cinch::Plugin
  include Utility

  # Match the command "!player <name>" and execute the desired actions
  match /player (.+)/
  def execute(m, nick)
    message = retrieve_player_data_string(nick)
    m.twitch(message)
  end

  # Retrieve the player data from https://oc.tc given the player's Minecraft
  # name
  def retrieve_player_data_string(nick)
    res = Utility::retrieve_html("https://oc.tc/#{nick}/")
    case res
    when Net::HTTPSuccess
      # parse link
      doc = Nokogiri::HTML(res.body)
      #doc.css('h2')
      "Successfully retrieved html!"
    when Net::HTTPRedirection
      "Redirected..."
    else
      "That player has not played on OCN."
    end
  end
end
