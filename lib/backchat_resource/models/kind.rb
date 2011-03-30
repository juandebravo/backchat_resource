module BackchatResource
  module Models
    # Read only:
    # A Kind model provides a more detailed description of the origin source of a message. They are child
    # objects of the Source model.
    # An example is a twitter timeline: Where "Twitter" would be the Source, and "timeline" would be the Kind
    class Kind < BackchatResource::Base
      schema do
        string '_id', 
               'auth_type',
               'description',
               'direction',
               'display_name', 
               'oauth_omniauth_provider',
               'protocol',
               'resource',
               'resource_display_name',
               'short_display_name'
      end
      
      belongs_to :source
      
      # @return {Kind} a Kind that matches the URL structure given as input
      def self.find_by_uri(uri)
        uri = Addressable::URI.parse(uri)
        nil # TODO
      end
      
    end
  end
end