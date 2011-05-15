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
      
      belongs_to :user
      
      validates_presence_of :slug, :name
      
      def before_save
        @attributes['slug'] = @attributes['name'].to_slug
      end
      
      # The ID of a stream for the API URL is it's slug
      # @return [string] stream slug
      def id
        return nil if self.slug.blank?
        self.slug
      end
      
      def slug
        @attributes['slug']
      end
      
      # 
      def serializable_hash(options = nil)
        {
          "name" => name,
          "slug" => slug,
          "description" => description,
          "channel_filters" => (channel_filters.is_a?(Array) ? channel_filters : [channel_filters]).inject([]) { |col, cf|
            col << {
              "channel" => cf.channel.to_s(false),
              "enabled" => cf.enabled?
            }
          }
        }
       end
      
      # Return an empty array
      # @return [Array<ChannelFilter>]
      def channel_filters
        @attributes["channel_filters"] || []
      end 
      
      # Set from an array of items
      # @param [Array<ChannelFilter>, Array<Hash>] new contents of channel_filters array
      def channel_filters=(val)
        val = [val] unless val.is_a?(Array)
        cfs = [] #val.collect { |cf| cf.is_a?(ChannelFilter) ? cf : ChannelFilter.new(cf)  }
        val.each do |cf|
          if cf.is_a?(ChannelFilter)
            cfs << cf
          elsif cf.is_a?(Hash)
            cfs << ChannelFilter.new(cf)
          end
        end
        @attributes["channel_filters"] = cfs
      end
      
      def description
        @attributes["description"] || ""
      end

      def name
        @attributes["name"]
      end

      # Set the name of the stream and generate a new slug based on it
      # @param [string] name of the stream
      # @note This also sets `slug` to a slug-safe version based on name
      def name=(name)
        @attributes['name'] = (name || "")
        @attributes['slug'] = @attributes['name'].to_slug
      end
      
      # @return [string, nil] The API URL for the stream or nil if there is no slug
      def api_url
        return nil if slug.blank?
        "#{self.class.site}#{BackchatResource::CONFIG['api']['message_stream_path']}#{slug}.#{self.class.format.extension}"
      end
      
      # Find streams using a channel
      # @return [Array<Stream>,nil]
      def self.find_streams_using_channel(ch)
        # /streams/for_channel
        # TODO!
        []
      end
            
    end
  end
end