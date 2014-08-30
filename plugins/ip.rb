class Ip
  include Cinch::Plugin

  match "ip"
  def execute(m)
    m.twitch("You can't join in the middle of a tournament! Find out more at https://oc.tc")
  end
end
