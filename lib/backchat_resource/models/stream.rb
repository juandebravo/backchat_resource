require 'backchat_resource/models/user'

module BackchatResource
  module Models
    class Stream < BackchatResource::Base      
      schema do
        string '_id',
               'slug',
               'name',
               'description'
        # Unsupported types are left as strings
        string 'channel_filters'
      end
      
      has_many :channel_filters
      belongs_to :user
      
      validates_presence_of :_id, :slug, :name
      
      # Return an empty array
      def channel_filters
        @attributes["channel_filters"] || []
      end
      
      # Set from an array of items
      def channel_filters=(params)
        params = [params] unless params.is_a?(Array)
        cfs = []
        params.each do |cf|
          cfs << cf
        end
        @channel_filters = cfs
      end
      
      # The ID of a stream for the API URL is it's slug
      def id
        slug
      end

      # Set the name of the stream and generate a new slug based on it
      def name=(name)
        @name = name
        self.slug = name.to_slug
      end
      
    end
  end
end