module BackchatResource
  module Models
    # This is not a BackchatResource backed model. It is just a class to store and manipulate 
    # Hash information from the JSON API.
    class ChannelFilter < BackchatResource::Base
      schema do 
        string "channel", "canonical_uri", "enabled"
      end

      belongs_to :stream
      
      attr_reader :channel

      # Set default values
      def initialize(*params)
        super
        params = HashWithIndifferentAccess.new(params.is_a?(Array) ? params.first : params)
        if params.is_a?(Hash)
          self.enabled = params["enabled"] if params.key?("enabled")          
          self.channel = params["channel"] || params["canonical_uri"]
          @channel = BackchatUri.parse(@attributes["channel"])
          @channel.bql = params["bql"] if params.key?("bql")
        elsif params.is_a?(String)
          self.channel = params
        elsif params.is_a?(Channel)
          self.channel = params.channel
          self.channel.bql = params.channel.bql
          self.enabled = false
        elsif params.is_a?(BackchatUri)
          self.channel = params
          self.channel.bql = params.bql
          self.enabled = false
        else
          super
        end
      end
      
      def enabled
        (@attributes["enabled"] == "1" || @attributes["enabled"] == "true" || @attributes["enabled"] == true) || false
      end
      alias_method :enabled?, :enabled
      
      def enabled=(val)
        @attributes["enabled"] = val
      end
      
      def canonical_uri
        @canonical_uri ||= BackchatUri.parse(@attributes["canonical_uri"])
      end
      
      def canonical_uri=(val)
        @attributes["canonical_uri"] = val #uri.to_s
        @canonical_uri = nil
      end
      
      def channel
        @channel ||= begin
          BackchatUri.parse(@attributes["channel"] || @attributes["canonical_uri"])
        rescue => e
          # TODO: Log parsing error
          raise e
        end
      end
      
      # The URI describes the channel filter
      # @param {String|BackchatUri} URI for the channel filter
      def channel=(channel)
        @attributes["channel"] = channel.to_s
        @channel = @canonical_uri = nil # clear cache
      end
      
      def bql
        channel.bql
      end
      
      # @param [string] BQL query to filter against the Channel
      def bql=(val)
        self.channel.bql = val
      end
      
      # Build a new instance of a ChannelFilter based on the input BackChat.io URI, or Hash
      # @param {Hash|BackchatUri|Hash}
      # @return {ChannelFilter}
      def self.build(param)
        if param.is_a?(Hash)
          new(param)
        else
          new(:channel => param)
        end
      end
      
    end
  end
end