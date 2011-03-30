module BackchatResource
  module Models
    class Channel < BackchatResource::Base
      schema do
        string '_id', 'uri'
      end
      
      validates_presence_of :_id, :uri
      
      # Populate the channel bassed on the URI, building up source and kind properties
      def uri=(uri)
        @uri = uri #TODO
      end
      
      # @return {Source}
      def source
        nil #TODO
      end
      
      # The message source-kind refines information of the source by defining a child-item
      # of the source... for instance, Twitter is the source, but Timeline is the kind
      # @return {Kind}
      def source_kind
        nil #TODO
      end
      
      # Build a new instance of Channel from a URL
      def self.build_from_api_response(doc)
        if doc.is_a?(String)
          # A URL
        elsif doc.is_a?(Hash)
          # A hash of URLs
          #{\"bare_uri\":\"{channel}://{host}\",\"full_uri\":\"smtp://adam.mojolly-crew\"}
        else
          raise "Expected an input of a String or Hash, got #{doc.class}"
        end
        true
      end
      
    end
  end
end