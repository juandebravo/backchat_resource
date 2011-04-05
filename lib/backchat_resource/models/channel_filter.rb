module BackchatResource
  module Models
    # This is not a BackchatResource backed model. It is just a class to store and manipulate 
    # Hash information from the JSON API.
    class ChannelFilter < BackchatResource::Base
      schema do 
        string "uri", "canonical_uri", "enabled"
      end

      belongs_to :stream
      
      attr_reader :uri, :bql

      # Set default values
      def initialize(options={})
        super(options)
        attributes["enabled"] ||= false
        
        self.uri = options[:uri] if options.key?(:uri)
        self.enabled = options[:enabled] if options.key?(:enabled)
        self.bql = options[:bql] if options.key?(:bql)
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
      
      def bql
        uri.bql
      end
      
      # @param [string] BQL query to filter against the Channel
      def bql=(bql)
        # @bql = bql
        # puts uri.inspect
        # (uri['params'] ||={})['bql'] = bql
        uri.bql = bql
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