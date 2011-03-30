# Load all the models into the module
module BackchatResource
  module Models
    autoload :User, 'backchat_resource/models/user'
    autoload :Stream, 'backchat_resource/models/stream'
    autoload :Channel, 'backchat_resource/models/channel'
    autoload :ChannelFilter, 'backchat_resource/models/channel_filter'
    autoload :Source, 'backchat_resource/models/source'
    autoload :Kind, 'backchat_resource/models/kind'
    autoload :Plan, 'backchat_resource/models/plan'
  end
end