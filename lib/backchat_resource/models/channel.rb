module BackchatResource
  module Models
    class Channel < BackchatResource::Base
      schema do
        string '_id', 'uri'
      end
      
      validates_presence_of :uri

      def initialize(*params)
        if params.length == 1
          if params.is_a?(String)
            self.uri = params
          elsif params.is_a?(Channel)
            self.uri = params.uri
          elsif params.is_a?(BackchatUri)
            self.uri = params.dup
          else
            super
          end
        else
          super
        end
      end
      
      def serializable_hash(options = nil)
        {
          :uri => @attributes["uri"]
        }
       end
      
      # Make a unique ID for this channel
      def id
        if @attributes["uri"]
          Digest::MD5.hexdigest(@attributes["uri"])
        else
          nil
        end
      end
      
      # TODO:
      # Access properties on the URI as if they were on the Channel
      # set source [Source,Kind,string]
      # set kind [Kind,string]
      # target
      # 
      
      # @return [Source,nil]
      def source
        @source ||= Source.find_for_uri(uri)
      end
      
      # The message source-kind refines information of the source by defining a child-item
      # of the source... for instance, Twitter is the source, but Timeline is the kind
      # @return [Kind,nil]
      def kind
        @kind ||= Kind.find_for_uri(uri)
      end
      
      # @return [BackchatUri]
      def uri
        @uri ||= BackchatUri.parse(@attributes["uri"])
      end
      
      def uri=(uri)
        super
        @uri = nil # clear cache
      end
      
      # def to_s
      #   uri.to_s
      # end
      
      # Build a new instance of Channel from a URL
      # @param [BackchatUri, string, Hash]
      # @return [Channel]
      def self.build_from_uri(doc)
        uri = nil
        if doc.is_a?(BackchatUri)
          uri = doc.dup
        elsif doc.is_a?(String)
          uri = doc
        elsif doc.is_a?(Hash)
          # A hash of URLs
          #{\"bare_uri\":\"{channel}://{host}\",\"full_uri\":\"smtp://adam.mojolly-crew\"}
          uri = doc["uri"]
        else
          raise "Expected an input of a String or Hash, got #{doc.class}"
        end
        new(:uri => uri)
      end
      
    end
  end
end