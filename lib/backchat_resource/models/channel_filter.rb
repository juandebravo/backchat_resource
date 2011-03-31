# This is not a BackchatResource backed model. It is just a class to store and manipulate 
# Hash information from the JSON API.
module BackchatResource
  module Models
    class ChannelFilter < BackchatResource::Base
      
      schema do 
        string "uri", "canonical_uri", "enabled"
      end

      belongs_to :stream
      
      attr_reader :bql

      # Set default values
      def initialize(options={})
        @working_uri = Addressable::URI.new
        super(options)
        attributes["enabled"] ||= false
      end
      
      # The URI describes the channel filter
      # @param {String|URI} URI for the channel filter
      def uri=(uri)
        uri = Addressable::URI.parse(uri) if uri.is_a?(String)
        @working_uri = uri
        attributes["uri"] = @working_uri.to_s
        # TODO
      end
      
      # @param {String} BQL query to filter against the Channel
      def bql=(bql)
        @bql = bql
        @working_uri.query_values = (@working_uri.query_values||{}).merge({:bql => bql})
        self.uri= @working_uri # store back in the 'uri' attribute
      end
      
      # Returns the channel being filtered by this filter instance, as defined
      # in the ChannelFilter's 'uri' attribute
      # @return {Channel} the channel being filtered by this instance
      def channel
        
      end
      
      # Build a new instance of a ChannelFilter based on the input BackChat.io URI
      # @param {String|URI}
      # @return {ChannelFilter}
      def self.build(uri)
        new(:uri => uri)
      end
      
    end
  end
end