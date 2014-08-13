# OCNBot | An IRC bot for OCN streamers

This is an IRC bot that is currently being developed by Jeremy K. ([CacklingPanda](https://oc.tc/cacklingpanda)) for the use of [Overcast Network](http://oc.tc) streamers on the [Twitch](http://twitch.tv) video streaming platform.

## Streamers

If you would like OCNBot to be added to your channel please [email me](mailto:cacklingpanda@gmail.com) with your Twitch information. However, remember that OCNBot is currently not being run 24/7 and will only be available when requested. To request that OCNBot be run please email me. 

## Your Own Bot

If you would like to have the functionality of OCNBot, but under a different name, then you can! This repo is public after all! To do this a couple of dependencies need to be installed. OCNBot uses the Cinch IRC framework. Install the ruby gem Cinch by running `gem install cinch` in your shell environment. Next, change the parameters in the ocnbot_router.rb file to your bot's name, nickname, and the desired channels to be run on. After that add a .secret file that has your [twitch.tv oauth password](http://www.twitchapps.com/tmi/). Now you are setup and ready to go!

Run `ruby ocnbot_router.rb` and your bot will be up and running! Enjoy!

## Contributing

If you want to contribute ot OCNBot's functionality simply make a pull request with your changes! It's that easy! 
