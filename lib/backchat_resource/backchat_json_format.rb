module ActiveResource
  module Formats
    module BackchatJsonFormat
      extend self
      
      def extension
        "json"
      end
      
      def mime_type
        'application/json'
      end
      
      # Encode into URL encoded string
      def encode(hash, options = {})
        hash.to_json
      end
      
      def decode(json)
        ActiveSupport::JSON.decode(json)
      end
      
    end
  end
end