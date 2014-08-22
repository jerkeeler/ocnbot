# This is a Cinch plugin that scans the httsp://oc.tc/teams pages for the team
# specified by the command sender and then it displays the team's stats. This 
# uses nokogiri to parse the HTML easily

require 'nokogiri'
require_relative 'utility'

class Team
  include Cinch::Plugin
  include Utility

  # Match to the team command and execute if the command 
  match /team (.+)/
  def execute(m, team)
    message = retrieve_team_string(team)
    m.twitch(message)
  end

  # Retrieve the team url by iterating through team pages until found
  def retrieve_team_url(team)
    @team_base_url = "https://oc.tc/teams?page="
    
    # Loop through team pages until one is found to contain the team in question
    page_num = 1
    exist = false
    returnurl = "DNE"

    until exist do
      url = "#{@team_base_url}#{page_num}/"
      res = Utility::retrieve_html(url)

      if res == !Net::HTTPSuccess || page_num > 100
        return "DNE"
      end

      # Get the team names and the links to each team page
      doc = Nokogiri::HTML(res.body)
      names = doc.xpath("//td/a[contains(@href, '/teams/')]").collect {|node| node.text.strip.downcase }
      links = doc.xpath("//td/a[contains(@href, '/teams/')]").collect {|node| node['href'] }
     
      # Check to see if the team you are searching for is here
      if names.include?(team.downcase)
        returnurl = links[names.index(team.downcase)]
        exist = true
      end
      page_num += 1
    end

    returnurl
  end

  # Retrieve the stats of a team and then format their stats into a nice string
  def retrieve_team_string(team)
    # Get the team's url or return that it doesn't exist
    puts team
    url = retrieve_team_url(team)
    return "Team does not exist or has less than one player!" if url == "DNE"
    
    # Retrieve the html and parse out the stats using Nokogiri
    res = Utility::retrieve_html("https://oc.tc#{url}")
    doc = Nokogiri::HTML(res.body)
    killstats = doc.xpath("//div[@class='span3']").collect { |node| node.text.strip }
    objstats = doc.xpath("//div[@class='span4']").collect { |node| node.text.strip }
    stats = Array.new()

    # Get stats into their own array
    killstats.each do |stat|
      stats.push(stat.split("\n")[1])
    end
    objstats.each do |stat|
      stats.push(stat.split("\n")[1])
    end

    # Produce nice string
    "#{team}: KD - #{stats[1]}, KK - #{stats[0]}, Kills - #{stats[2]}, Deaths - #{stats[3]}, Wools - #{stats[4]}, Cores - #{stats[5]}, Monuments - #{stats[6]}"
  end
end
