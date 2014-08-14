# This plugin 
class Player
	include Cinch::Plugin

	match /player (.+)/
	def execute(m, nick)
		m.twitch("Searching for #{nick}?")
	end
end
