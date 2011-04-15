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
      def initialize(*params)
        if params.length == 1
          if params.is_a?(Hash)
            self.uri = options[:uri] if options.key?(:uri)
            self.bql = options[:bql] if options.key?(:bql)
            self.enabled = options[:enabled] if options.key?(:enabled)
          elsif params.is_a?(String)
            self.uri = params
          elsif params.is_a?(Channel)
            self.uri = params.uri
            self.bql = params.uri.bql
            self.enabled = false
          elsif params.is_a?(BackchatUri)
            self.uri = params
            self.bql = params.uri.bql
            self.enabled = false
          else
            super
          end
        else
          super
        end
      end
      
      # def initialize(options={})
      #   super(options)
      #   attributes["enabled"] ||= false
      #   
      #   self.uri = options[:uri] if options.key?(:uri)
      #   self.enabled = options[:enabled] if options.key?(:enabled)
      #   self.bql = options[:bql] if options.key?(:bql)
      # end
      
      def enabled
        @attributes["enabled"]
      end
      alias_method :enabled?, :enabled
      
      # def enabled=(val)
      #   @attributes["enabled"] = val
      # end
      
      def canonical_uri
        @canonical_uri ||= BackchatUri.parse(@attributes["canonical_uri"])
      end
      
      def canonical_uri=(val)
        @attributes["canonical_uri"] = uri.to_s
        @canonical_uri = nil
      end
      
      def uri
        @uri ||= BackchatUri.parse(@attributes["uri"])
      end
      
      # The URI describes the channel filter
      # @param {String|BackchatUri} URI for the channel filter
      def uri=(uri)
        puts "I JUST SET THE URI= #{uri.inspect}"
        puts caller.first.inspect
        @attributes["uri"] = uri.to_s
        @uri = @canonical_uri = nil # clear cache
      end
      
      def bql
        # puts "b"*100 + @attributes["bql"] + "\n" + uri.inspect
        # uri.bql
        @attributes["bql"]
      end
      
      # @param [string] BQL query to filter against the Channel
      def bql=(val)
        self.uri.bql = val
        @attributes["uri"] = uri.to_s
        puts "I JUST SET THE URI BQL PARAM: #{self.uri.bql}, #{self.uri.to_s}"
        @attributes["bql"] = val
        @uri = nil
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