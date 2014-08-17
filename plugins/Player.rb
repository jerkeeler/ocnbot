# This plugin's purpose is to display player stats from https://oc.tc when the 
# command !player <name> is given. The stats format should be displayed like 
# "PlayerName: Kills - 11, Deaths - 11, KD - 1, KK - 2, Wools - 1, Cores - 1, Monuments - 1, Playtime - 1 hour"

require 'nokogiri'
require_relative 'utility'

class Player
  include Cinch::Plugin
  include Utility

  # Match the command "!player <name>" and execute the desired actions
  match /player (.+)/
  def execute(m, nick)
    message = "#{nick}: #{retrieve_player_data_string(nick)}"
    m.twitch(message)
  end

  # Retrieve the player data from https://oc.tc given the player's Minecraft
  # name
  def retrieve_player_data_string(nick, url = false)
    res = url ? Utility::retrieve_html(nick) : Utility::retrieve_html("https://oc.tc/#{nick}/")

    # Check what the server response was and do correct action
    case res
    when Net::HTTPSuccess
      parse_html_for_stats(res)
    when Net::HTTPRedirection
      retrieve_player_data_string(res['location'], true)
    else
      "That player has not played on OCN."
    end
  end

  # Given a html response from a https://oc.tc/name parse the html using Nokogiri
  # and produce a string representation of the player's stats
  def parse_html_for_stats(res)
    doc = Nokogiri::HTML(res.body)
    stats_text = doc.css('h2')
    stats = Array.new()

    # Iterate through all h2 elements and retrieve the data values
    stats_text.each do |text|
      stats.push(text.text.split("\n")[1])
    end

    "Kills - #{stats[0]}, Deaths - #{stats[1]}, KD - #{stats[3]}, KK - #{stats[4]}, Wools - #{stats[8]}, Cores - #{stats[9]}, Monuments - #{stats[10]}, Playtime - #{stats[6]} days"
  end
end
