module BackchatResource
  module Models
    class Stream < BackchatResource::Base
      schema do
        string '_id', 'slug', 'name', 'description'
      end
      
      validates_presence_of :_id, :slug, :name
      
      # The ID of a stream for the API URL is it's slug
      def id
        slug
      end
      
    end
  end
end