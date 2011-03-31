# Read Only:
# Pricing plan for BackChat.io
module BackchatResource
  module Models
    class Plan < BackchatResource::Base
      schema do
        string 'name',
               'streams_limit', 
               'channels_limit',
               'traffic_limit',
               'traffic_unit',
               'messages_limit', 
               'price',
               'sort_order',
               'traffic_unit'
      end
      
      belongs_to :user
      
      # @return {string} Plan name as ID
      def id
        name.downcase
      end
      
      # Returns the URI of this Plan on the Backend API
      def api_url
        "#{self.class.site}#{BackchatResource::CONFIG['api']['plans_path']}#{id}.#{self.class.format.extension}"
      end
      
      def self.find_by_uri(uri)
        response = connection.get(uri)
        new(response)
      end
      
      def to_json
        uri
      end
      
    end
  end
end