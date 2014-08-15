# This plugin's purpose is to display player stats from https://oc.tc when the command 
# !player <name> is given. The stats format should be displayed like 
# "PlayerName: Kills - 11, Deaths - 11, KD - 1, KK - 2, Wools - 1, Cores - 1, Monuments - 1, Playtime - 1 hour"
require 'net/https'
require 'uri'

class Player
	include Cinch::Plugin

	match /player (.+)/
	def execute(m, nick)
		message = retrieve_player_data(nick)
		m.twitch(message)
	end

	def retrieve_player_data(nick)
		uri = URI.parse("https://secure.com/")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)
		puts response.body
		response.status
		response["header-here"] # All headers are lowercase
		puts response.body

		return "Success retrieving #{nick}'s data!"
	end
end
