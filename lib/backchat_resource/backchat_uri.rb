# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class BackchatUri
    
    attr_accessor :expanded, :uri_s
    # @expanded = {}
    # @uri_s = nil
    
    def initialize(param={})
      if param.is_a?(String)
        @uri_s = param
        @expanded = expand_uri(@uri_s)
      elsif param.is_a?(Hash)
        @uri_s = to_canonical_s
        @expanded = param
      elsif param.is_a?(BackchatUri)
        @uri_s = param.uri_s
        @expanded = param.expanded
      end
    end
    
    def expanded
      if @expanded.nil?
        @expanded = (expand_uri(@uri_s) || {})
      end
      @expanded
    end
    
    # Read only
    # @return [Source] A Source model instance describing the source associated with this URI
    def source
      @source ||= Source.new(expanded['source'])
    end
        
    # Read only
    # @return [Kind] A Kind model instance describing the kind associated with this URI
    def kind
      @kind ||= Kind.new(expanded['kind'])
    end
    
    # Uhhh... it provides some extra info for odd use cases. Rarely used.
    # i.e. Voice/SMS
    # @return [String]
    def kind_resource
      expanded['kind_resource']
    end
    
    # @param [String] Set the resource kind for this URI
    def kind_resource=(val)
      expanded['kind_resource'] = val
      recompose_uri
    end
    
    # @return [Hash] Any querystring parameters for this URI
    def querystring_params
      expanded['params'] ||= {}
    end
    
    # The target of a BackChat URI varies on context. In a twitter channel the target is
    # the username, or in an RSS feed the target is the URL of the XML document.
    # @return [String]
    def target
      expanded['target']
    end
    
    # @param [String] new target for this BackChat URI
    def target=(val)
      expanded['target'] = val
      recompose_uri
    end
    
    def bql
      querystring_params["bql"]
    end
    
    def bql=(bql)
      querystring_params["bql"] = bql
      recompose_uri
    end
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(options={ :escape_hash => false })
      # POST back to build_uri endpoint with @expanded and the {:source=>value}
      # recompose_uri
      if options && options.key?(:escape_hash) && options[:escape_hash] == true
        expanded['canonical_uri'].gsub('#','%23') rescue nil
      else
        expanded['canonical_uri']
      end
    end
    
    def to_s(options={:escape_hash => false})
      uri_s = to_canonical_s(options)
    end
    
    # Parse a URI string into a BackchatUri
    # Attributes are downcased later on in the life cycle. See DOWNCASED_ATTRIBUTES
    # @params String uri_s
    def self.parse(uri_s)
      new uri_s
    end
    
    # @return [Hash] expanded URI data
    def expand_uri(uri_s)
      response = BackchatResource::Base.connection.get(expand_uri_uri(uri_s), BackchatResource::Base.headers)
      data = response['data'].first
      if data.is_a?(Array)
        data.last # ["key",{data}]
      else
        data
      end
    end
    
    protected
    
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
    
    # Refresh a URI with the API expand URI endpoint, updating the URI @expanded state
    def recompose_uri
      return "" if expanded.empty?
      
      payload = {
        :original_uri => @expanded['canonical_uri'],
        :target => @expanded['target'],
        :params => querystring_params,
        :kind_resource => @expanded['kind_resource'],
        :source => (@expanded['source'] || {})['_id'],
        :kind => (@expanded['kind'] || {})['_id']
      }
      response = BackchatResource::Base.connection.get(BackchatUri.compose_uri_uri(payload), BackchatResource::Base.headers)
      data = response['data']
      @expanded = if data.is_a?(Array)
        data.last # ["key",{data}]
      else
        data
      end
    end
    
    # @param [Hash] querystring params
    # @return [String] URI to the compose URI endpoint
    def self.compose_uri_uri(params)
      params.delete_if {|key, value| value.blank? }
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['compose_uri_path']}?#{params.to_query}"
    end
    
    # @param [String] URI to expand
    # @return [String] URI to the expand endpoint
    def expand_uri_uri(uri)
      # %2523 is %23 double-encoded
      URI.escape "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}?channel=#{uri.to_s}"
    end
    
  end
end