module BackchatResource
  module Models
    class ChannelFilter < BackchatResource::Base
      schema do
        string 'uri', 
               'canonical_uri', 
               'enabled'
      end
      
      belongs_to :stream
      
    end
  end
end