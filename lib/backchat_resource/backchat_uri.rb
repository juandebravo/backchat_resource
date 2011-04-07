require 'cgi'

# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class BackchatUri
    
    # attr_accessor :expanded, :uri_s
    @expanded = {
      'source' => nil,
      'kind' => nil,
      'kind_resource' => nil,
      'params' => nil,
      'target' => nil,
      'bql' => nil,
      'canonical_uri' => nil,
    }
    @uri_s = nil
    
    def initialize(param={})
      if param.is_a?(String)
        @uri_s = param
        @expanded = expand_uri(@uri_s)
        
        # TODO:
        # Unescape the BQL on this
        if @expanded["params"]
          @expanded["params"]["bql"] = CGI.unescape(@expand_uri["params"]["bql"] || "")
        end
        
      elsif param.is_a?(Hash)
        @uri_s = to_canonical_s
        @expanded = param
        if @expanded["params"]
          @expanded["params"]["bql"] = CGI.unescape(@expand_uri["params"]["bql"] || "")
        end
      # elsif param.is_a?(BackchatUri)
      #   @uri_s = param.uri_s
      #   @expanded = param.expanded
      end
    end
    
    # @return the URI sring being
    def uri_s
      @uri_s
    end
    
    def components
      if !@expanded && @uri_s
        @expanded = (expand_uri(@uri_s) || {
          'source' => nil,
          'kind' => nil,
          'kind_resource' => nil,
          'params' => nil,
          'target' => nil,
          'bql' => nil,
          'canonical_uri' => nil,
        })
      end
      @expanded
    end
    
    # Read only
    # @return [Source] A Source model instance describing the source associated with this URI
    def source
      @source ||= Source.new(@expanded['source'])
    end
        
    # Read only
    # @return [Kind] A Kind model instance describing the kind associated with this URI
    def kind
      @kind ||= Kind.new(@expanded['kind'])
    end
    
    # Uhhh... it provides some extra info for odd use cases. Rarely used.
    # i.e. Voice/SMS
    # @return [String]
    def kind_resource
      @expanded['kind_resource']
    end
    
    # @param [String] Set the resource kind for this URI
    def kind_resource=(val)
      @expanded['kind_resource'] = val
      # recompose_uri
    end
    
    # @return [Hash] Any querystring parameters for this URI
    def querystring_params
      @expanded['params'] ||= {}
      # recompose_uri
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
      # recompose_uri
    end
    
    def bql
      querystring_params["bql"]
    end
    
    def bql=(bql)
      querystring_params["bql"] = bql
      # recompose_uri
    end
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(escape = false)
      # escape ? URI.escape(expanded['canonical_uri']) : expanded['canonical_uri']
      recompose_uri
      @expanded['canonical_uri']
    end
    
    def to_s(escape = false)
      to_canonical_s(escape)
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
    
    # def bql_looks_to_be_escaped?
    #   # If it has an encoded space then it's highly probable
    #   if self.bql.include?('%20') || 
    #     self.bql.include?('%2523') # double-escaped #
    #     true
    #   end
    #   false
    # end
    
    # Refresh a URI with the API expand URI endpoint, updating the URI @expanded state
    def recompose_uri
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
      if data.is_a?(Array)
        @expanded = data.last # ["key",{data}]
      else
        @expanded = data
      end
      # if bql_looks_to_be_escaped?
      #   self.bql = URI.unescape(self.bql)
      # # (@expanded['params'] || {}).each do |k,v|
      # #   @expanded['params'][k] = URI.unescape(v)
      # end
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
      # uri = (uri || "").to_s
      # 
      # if uri.include?('%2520') || # double-escaped space
      #    uri.include?('%2522') || # double-escaped "
      #    uri.include?('%2523')    # double-escaped #
      #   uri = URI.unescape(uri.to_s)
      # elsif uri.include?(' ') ||  # unescaped space
      #    uri.include?('"')        # unescaped quote
      #   uri = URI.escape(uri.to_s)
      # end
      
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}?channel=#{CGI.escape uri}" ##{ {"channel"=> uri }.to_query }"
    end
    
  end
end