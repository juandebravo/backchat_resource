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
      
      # @param [string] BQL query to filter against the Channel
      def bql=(bql)
        @bql = bql
        @working_uri.query_values = (@working_uri.query_values||{}).merge({:bql => bql})
        self.uri= @working_uri # store back in the 'uri' attribute
      end
      
      # Build a new instance of a ChannelFilter based on the input BackChat.io URI, or Hash
      # @param {String|URI|Hash}
      # @return {ChannelFilter}
      def self.build(param)
        if param.is_a?(Hash)
          super(param)
        else
          new(:uri => param)
        end
      end
      
    end
  end
end