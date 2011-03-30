module BackchatResource
  module Models
    # Read only:
    # A Source model describes the origin source of a message: such as twitter, email, RSS, XMPP, etc
    class Source < BackchatResource::Base
      schema do
        string '_id', 
               'category', 
               'created_at', 
               'default_auth_kind', 
               'default_bare_uri_template', 
               'default_canonical_uri_template', 
               'default_kind', 
               'display_name', 
               'enabled', 
               'kinds', 
               'parse_templates',
               'updated_at'
      end
      
      has_many :kinds

      # @return {Source} a Source that matches the URL structure given as input
      def self.find_by_uri(uri)
        uri = Addressable::URI.parse(uri)
        nil # TODO
      end
      
    end
  end
end