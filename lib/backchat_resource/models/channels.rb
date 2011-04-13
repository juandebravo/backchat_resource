# Load all the models into the module
module BackchatResource
  module Models
    module Channels
      autoload :Generic, 'backchat_resource/models/channels/generic'
      autoload :Webfeed, 'backchat_resource/models/channels/webfeed'
      autoload :EmailDropbox, 'backchat_resource/models/channels/email_dropbox'
      autoload :TwitterTimeline, 'backchat_resource/models/channels/twitter_timeline'
    end
  end
end