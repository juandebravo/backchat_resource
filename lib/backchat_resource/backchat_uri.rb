# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class BackchatUri
    
    attr_accessor :uri
    
    @expanded = {}
    
    def initialize(param={})
      @uri = nil
    
      if param.is_a?(String)
        @uri = param
        @expanded = self.expand_uri(@uri)
      elsif param.is_a?(Hash)
        @expanded = param
        @uri = to_canonical_s
      elsif param.is_a?(BackchatUri)
        @expanded = param.expanded.clone
        @uri = param.to_canonical_s
      end
    end
    
    # @return [Source] A Source model instance describing the source associated with this URI
    def source
      @source ||= Source.new(@expanded['source'])
    end
        
    # @return [Kind] A Kind model instance describing the kind associated with this URI
    def kind
      @kind ||= Kind.new(@expanded['kind'])
    end
    
    # Uhhh... it provides some extra info for odd use cases. Rarely used.
    # i.e. Voice/SMS
    def resource_kind
      @expanded['resource_kind']
    end
    
    # @param [String] Set the resource kind for this URI
    def resource_kind=(val)
      @expanded['resource_kind'] = val
    end
    
    # @return [Hash] Any querystring parameters for this URI
    def params
      @expanded['params'] ||= {}
    end
    
    # The target of a BackChat URI varies on context. In a twitter channel the target is
    # the username, or in an RSS feed the target is the URL of the XML document.
    # @return [String]
    def target
      @expanded['target']
    end
    
    # @param [String] new target for this BackChat URI
    def target=(val)
      @expanded['target'] = val
    end
    
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(options={ :escape_hash => false })
      # POST back to build_uri endpoint with @expanded and the {:source=>value}
      recompose_uri
      @expanded['canonical_uri']
    end
    
    def to_s
      to_canonical_s
    end
    
    # Parse a BackchatUriString into a hash
    # Attributes are downcased later on in the life cycle. See DOWNCASED_ATTRIBUTES
    # @params String uri_s
    def self.parse(uri_s)
      new(expand_uri(uri_s))
    end
    
    def self.expand_uri(uri_s)
      uri = URI.escape(uri_s)
      p = {}
      
      response = BackchatResource::Base.connection.get("#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}?channel=#{uri}", BackchatResource::Base.headers)
      
      response['data'].first.last
    end
    
    # Base64 encode a string in a URL safe format
    # @params String 
    def self.encode_b64_urlsafe(s)
      encoded = [s].pack('m').tr('+/','-_').gsub("\n",'')
    end
    
    # Base64 decode a string in a URL safe format
    # @params String base64-urlsafe encoded string to decode
    def self.encode_b64_urlsafe(s)
      decoded = s.tr('-_','+/').unpack('m')[0]
    end
    
    protected
    
    # Refresh a URI with the API expand URI endpoint, updating the URI @expanded state
    def recompose_uri
      return "" if @expanded.empty?
      
      payload = {
        :canonical_uri => @expanded['canonical_uri'],
        :target => @expanded['target'],
        :params => params,
        :resource_kind => @expanded['resource_kind'],
        :source => (@expanded['source'] || {})['_id'],
        :kind => (@expanded['kind'] || {})['_id']
      }.to_query
      response = BackchatResource::Base.connection.post("#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['compose_uri_path']}", payload, BackchatResource::Base.headers)
      @expanded = response['data']
    end
    
  end
end