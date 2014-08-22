# This class is a Cinch plugin that listens on message join. If the message
# contains a link to an OCN forum topic it will post the title of the topic.
# TODO: Add support for multiple links in the same message

require 'nokogiri'
require_relative 'utility'

class OCNTopic
  include Cinch::Plugin
 
  # Listen for messages
  listen_to :message
  def listen(m)
    m.twitch(get_topic_title(get_ocn_url(m.message))) if m.message.include?("oc.tc/forums/topics")
  end

  # Retrieve the ocn url that was pasted inside of the message
  def get_ocn_url(message)
    message.split(" ").each do |word|
      return word if word.include?("oc.tc/forums/topics")
    end
  end

  # Get the topic title based on the OCN url and using Nokogiri
  def get_topic_title(url)
    res = Utility::retrieve_html(url)

    case res
    when Net::HTTPSuccess
      doc = Nokogiri::HTML(res.body)
      doc.css('title')[0].text.split("\n")[1]
    else
      "OCN could not be reached!"
    end
  end
end
