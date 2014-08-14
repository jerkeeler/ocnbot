# First test plugin for cinch
# Using plugins to better compartamentalize the components
# This little plugin simply responds with hello!
class Hello
	include Cinch::Plugin

	match "hello"
	def execute(m)
		m.twitch("Hello, #{m.user.nick}!")
	end
end
