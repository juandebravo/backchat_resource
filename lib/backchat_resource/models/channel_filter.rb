module BackchatResource
  module Models
    class ChannelFilter < BackchatResource::Base
      schema do
        string 'uri', 
               'canonical_uri', 
               'enabled'
      end
    end
  end
end