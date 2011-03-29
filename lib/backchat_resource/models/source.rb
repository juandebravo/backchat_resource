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
    end
  end
end