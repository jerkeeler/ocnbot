# This program runs an IRC bot that connects to Twitch (http://twitch.tv) and 
# provides functionality for OCN (https://oc.tc) streamers.
#
# Author:: Jeremy K. (cacklingpanda@gmail.com)
# License:: This distributes under the MIT License

# This class initializes the bot into the designated IRC channels, loads 
# different plugins that have been developed for it and add Twitch integration
# into the Cinch gem.

require 'cinch'
require_relative './plugins/plugin_helper'

# Twitch IRC parameters
host = "irc.twitch.tv"
user = "OCNBot"
nick = "OCNBot"
port = 6667

# List of channels to join
# TODO: Make own method and abstract list of channels to a file
channels = ["#cacklingpanda"]

# Plugins to load, class names
load_plugins = [Hello, Player, Status]

# Filepath to the password file
pass_file = ".secret"

# Simple method for reading the OAuth password from a file
def secure_pass(filepath)
  pass_file = filepath
  if File.exist?(pass_file)
    File.read(pass_file).chomp
  else
    abort("No password file found!")
  end
end

password = secure_pass(pass_file)

# Add twitch method to message object to allow the bot to send messages to twitch
# Fixes error where Cinch bot cannot message "non-irc, but irc-esque" servers
class Cinch::Message
  def twitch(string)
    string = string.to_s.gsub('<','&lt;').gsub('>','&gt;')
    bot.irc.send ":#{bot.config.user}!#{bot.config.user}@#{bot.config.user}.tmi.twitch.tv PRIVMSG #{channel} :#{string}"
  end
end

# Create a Cinch bot
bot = Cinch::Bot.new do
  configure do |c|
    c.server = host
    c.user = user
    c.nick = nick
    c.password = password
    c.channels = channels
    c.plugins.plugins = load_plugins
  end
end

# Start the bot!
bot.start
