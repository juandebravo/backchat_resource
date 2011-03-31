module BackchatResource
  module Models
    # Read only:
    # A Source model describes the origin source of a message: such as twitter, email, RSS, XMPP, etc
    class Source < BackchatResource::Base
      schema do
        string '_id', 
               'category', 
               'default_auth_kind', 
               'default_bare_uri_template', 
               'default_canonical_uri_template', 
               'default_kind', 
               'display_name', 
               'enabled'
        # More complex types are for now represented as strings until ActiveResource gets it's act together
        string 'kinds', 
               'parse_templates'
      end
      
      def id
        @id ||= _id.downcase
      end
      
      def kinds
        @kinds || []
      end
      
      # Set the kinds available on this Source
      def kinds=(arr)
        knds = []
        arr.each do |param|
          if param.is_a?(Hash)
            knds << Kind.new(param)
          elsif param.is_a?(Kind)
            knds << param
          end
        end
        @kinds = knds
      end
      
      def self.all
        @@cached_sources ||= super
      end
      
      # Find a Source that would match the passed URI
      # @param {string|URI}
      def self.find_for_uri(uri)
        uri = Addressable::URI.parse(uri) if uri.is_a?(String)
        return nil if uri.scheme.blank?
        self.all.select { |src| src.id == uri.scheme.downcase }.first
      end
      
    end
    
    # Read only:
    # A Kind model provides a more detailed description of the origin source of a message. They are child
    # objects of the Source model, and not actually belonging to an API endpoint.
    # An example is a twitter timeline: Where "Twitter" would be the Source, and "timeline" would be the Kind
    class Kind
      extend ActiveModel::Naming
      include ActiveModel::Serializers::JSON
      include ActiveModel::Conversion
      
      self.include_root_in_json = false
      
      # TODO: Is all this worry about serializing a Kind into JSON worth it? 
      # When do we serialize it, rather than reference it in a model we post back to the API?
      
      attr_accessor :attributes
      def initialize(attributes)
        @attributes = attributes
      end
      
      def persisted?
        true
      end
       
      def id
        (@attributes["_id"] || "").downcase
      end

      def _id
        @attributes["_id"]
      end
      def _id=(value)
        @attributes["_id"] = value
      end
            
      def description
        @attributes["description"]
      end
      def description=(value)
        @attributes["description"] = value
      end

      def direction
        @attributes["direction"]
      end
      def direction=(value)
        @attributes["direction"] = value
      end
      
      def display_name
        @attributes["display_name"]
      end
      def display_name=(value)
        @attributes["display_name"] = value
      end
      
      def oauth_omniauth_provider
        @attributes["oauth_omniauth_provider"]
      end
      def oauth_omniauth_provider=(value)
        @attributes["oauth_omniauth_provider"] = value
      end
      
      def oauth_version
        @attributes["oauth_version"]
      end
      def oauth_version=(value)
        @attributes["oauth_version"] = value
      end
      
      def protocol
        @attributes["protocol"]
      end
      def protocol=(value)
        @attributes["protocol"] = value
      end
      
      def requires_oauth
        @attributes["requires_oauth"]
      end
      def requires_oauth=(value)
        @attributes["requires_oauth"] = value
      end
      
      def requires_user_password
        @attributes["requires_user_password"]
      end
      def requires_user_password=(value)
        @attributes["requires_user_password"] = value
      end
      
      def short_display_name
        @attributes["short_display_name"]
      end
      def short_display_name=(value)
        @attributes["short_display_name"] = value
      end
      
      def auth_type
        @attributes["auth_type"]
      end
      def auth_type=(value)
        @attributes["auth_type"] = value
      end
      
      # @return {Kind} a Kind that matches the URL structure given as input
      def self.find_for_uri(uri)
        uri = Addressable::URI.parse(uri) if uri.is_a?(String)
        src = Source.find_for_uri(uri)
        return nil if src.nil? || src.kinds.blank?
        kind = src.kinds.select { |knd| knd.id == uri.fragment.downcase }.first
        if kind.nil?
          kind = src.kinds.select { |knd| knd.id == src.default_kind }.first
        end
        return kind
      end
      
    end
  end
end