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
      # @return [Array<ChannelFilter>]
      def channel_filters
        @attributes["channel_filters"] || []
      end 
      
      # Set from an array of items
      # @param [Array<ChannelFilter>, Array<Hash>] new contents of channel_filters array
      def channel_filters=(params)
        params = [params] unless params.is_a?(Array)
        cfs = []
        params.each do |cf|
          if cf.is_a?(ChannelFilter)
            cfs << cf
          else
            cfs << ChannelFilter.new(cf)
          end
        end
        @channel_filters = cfs
      end
      
      # The ID of a stream for the API URL is it's slug
      # @return [string] stream slug
      def id
        slug
      end

      # Set the name of the stream and generate a new slug based on it
      # @param [string] name of the stream
      # @note This also sets `slug` to a slug-safe version based on name
      def name=(name)
        super(name)
        self.slug = (name || "").to_slug
      end
      
      # @return [string, nil] The API URL for the stream or nil if there is no slug
      def api_url
        return nil if slug.blank?
        "#{self.class.site}#{BackchatResource::CONFIG['api']['message_stream_path']}#{slug}.#{self.class.format.extension}"
      end
      
    end
  end
end