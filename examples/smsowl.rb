#
# SMSOwl.com demo script
#
# SMSOwl is a web service that takes SMS's containg the hashtag '#owl' and copes those messages into the user's
# twitter stream.
#
# The following example shows how SMSOwl.com uses BackchatResource to configure BackChat.io for this use case.
#

# So we have direct access to models without namespaces
include BackchatResource::Models

new_user_twitter_name = "newuser" # This is collected from the Ruby on Rails postback data
new_user_o2_mobile_phone_number = "075678987657"

# Open the connection to the BackChat.io API
bc_smsowl = User.authenticate("smsowlusername","smsowlpassword")
hashblue_ch = Channel.new :uri => "hashblue://#{new_user_o2_mobile_phone_number}"

owl_stream = Stream.new :name => "SMSOwl.com #{new_user_o2_mobile_phone_number} to #{new_user_twitter_name}"
owl_stream.channel_filters.new hashblue_ch

bc_smsowl.channels.add hashblue_ch
bc_smsowl.streams.add 

bc_smsowl.save