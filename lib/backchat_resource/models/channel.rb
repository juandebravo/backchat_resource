module BackchatResource
  module Models
    class Channel < BackchatResource::Base
      schema do
        string '_id', 'uri'
      end
      
      validates_presence_of :_id, :uri
    end
  end
end