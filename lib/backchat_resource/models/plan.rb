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
      
      # @return [string] Plan name as ID
      def id
        name.downcase
      end
      
      # @return [string] the URI of this Plan on the Backend API
      def api_url
        "#{self.class.site}#{BackchatResource::CONFIG['api']['plans_path']}#{id}.#{self.class.format.extension}"
      end

      class << self

        def __cache__
          @@__plan_cache__ ||= Cache.new(:max_num => 10)
        end
        
        # @return [Plan] get a Plan instance populated with the contents of an API Plan URL
        def get_from_url(uri)
          unless __cache__[uri]
            response = connection.get(uri)
            __cache__[uri] = new(response)
          end
          __cache__[uri]
        end
      end

      def to_json
        uri
      end
      
    end
  end
end
