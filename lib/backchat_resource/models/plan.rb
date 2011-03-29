module BackchatResource
  module Models
    # Pricing plan for BackChat.io
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
    end
  end
end