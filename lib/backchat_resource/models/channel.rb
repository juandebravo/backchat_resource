module BackchatResource
  module Models
    class Channel < BackchatResource::Base
      schema do
        string '_id', 'uri'
      end
      
      validates_presence_of :_id, :uri
      
      # TODO:
      # Access properties on the URI as if they were on the Channel
      # set source [Source,Kind,string]
      # set kind [Kind,string]
      # target
      # 
      
      # @return [Source]
      def source
        @source ||= Source.find_for_uri(uri)
      end
      
      # The message source-kind refines information of the source by defining a child-item
      # of the source... for instance, Twitter is the source, but Timeline is the kind
      # @return [Kind]
      def kind
        @kind ||= Kind.find_for_uri(uri)
      end
      
      # @return [BackchatUri]
      def uri
        @uri ||= (begin
          if @attributes["uri"].is_a?(String)
            BackchatUri.parse(@attributes["uri"])
          else
            @attributes["uri"]
          end
        end)
      end
      
      def uri=(uri)
        @uri = nil # clear cache
        super(uri)
      end
      
      # Build a new instance of Channel from a URL
      # @param [BackchatUri, string, Hash]
      # @return [Channel]
      def self.build_from_uri(doc)
        uri = nil
        if doc.is_a?(BackchatUri)
          uri = doc
        elsif doc.is_a?(String)
          uri = doc
        elsif doc.is_a?(Hash)
          # A hash of URLs
          #{\"bare_uri\":\"{channel}://{host}\",\"full_uri\":\"smtp://adam.mojolly-crew\"}
          uri = doc["full_uri"]
        else
          raise "Expected an input of a String or Hash, got #{doc.class}"
        end
        new(:uri => uri)
      end
      
    end
  end
end