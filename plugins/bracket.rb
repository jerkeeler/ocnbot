class Bracket
  include Cinch::Plugin

  match "bracket"
  def execute(m)
    m.twitch("Find the Guardians of the Wool bracket here! http://ocn.challonge.com/GOTW")
  end
end
