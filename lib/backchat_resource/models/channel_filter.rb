module BackchatResource
  module Models
    # This is not a BackchatResource backed model. It is just a class to store and manipulate 
    # Hash information from the JSON API.
    class ChannelFilter < BackchatResource::Base      
      schema do 
        string "uri", "canonical_uri", "enabled"
      end

      belongs_to :stream
      
      attr_reader :bql

      # Set default values
      def initialize(options={})
        @uri = BackchatUri.new
        super(options)
        attributes["enabled"] ||= false
      end
      
      def uri
        @uri ||= BackchatUri.parse(@attributes["uri"])
      end
      
      # The URI describes the channel filter
      # @param {String|BackchatUri} URI for the channel filter
      def uri=(uri)
        @attributes["uri"] = uri.to_s
        @uri = nil # clear cache
      end
      
      # @param [string] BQL query to filter against the Channel
      def bql=(bql)
        @bql = bql
        uri.query_values = (uri.query_values||{}).merge({:bql => bql})
        self.uri = uri # store back in the 'uri' attribute
      end
      
      # Build a new instance of a ChannelFilter based on the input BackChat.io URI, or Hash
      # @param {String|BackchatUri|Hash}
      # @return {ChannelFilter}
      def self.build(param)
        if param.is_a?(Hash)
          new(param)
        else
          new(:uri => param)
        end
      end
      
    end
  end
end