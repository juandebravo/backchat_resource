# Read only:
# A Source model describes the origin source of a message: such as twitter, email, RSS, XMPP, etc
module BackchatResource
  module Models
    class Source < BackchatResource::Base
      # self.element_name    = "sources"
      # self.collection_name = "sources"
      
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
      
    end
  end
end