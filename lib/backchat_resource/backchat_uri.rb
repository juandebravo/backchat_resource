require 'active_model'
require 'cgi'

# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class BackchatUri
    include ActiveModel::Dirty
    attr_accessor :attributes
        
    # attr_accessor :expanded, :uri_s
    @attributes = {
      'source' => nil,
      'kind' => nil,
      'kind_resource' => nil,
      'params' => {},
      'target' => nil,
      'bql' => nil,
      'canonical_uri' => nil,
    }
    @uri_s = nil
    
    def initialize(param={})
      if param.is_a?(String)
        @uri_s = param
        attributes = expand_uri(@uri_s)
        if attributes && attributes["params"]
          attributes["params"]["bql"] = CGI.unescape(@expand_uri["params"]["bql"] || "")
        end
        
      elsif param.is_a?(Hash)
        @uri_s = to_canonical_s
        attributes = param
        if attributes["params"]
          attributes["params"]["bql"] = CGI.unescape(@expand_uri["params"]["bql"] || "")
        end
      elsif param.is_a?(BackchatUri)
        @uri_s = param.uri_s
        attributes = param.attributes.dup
      end
    end
    
    # @return the URI sring being
    def uri_s
      @uri_s
    end
    
    def attributes
      if !@attributes && @uri_s
        @attributes = expand_uri(@uri_s)
      end
      if !@attributes
        @attributes = {
          'source' => nil,
          'kind' => nil,
          'kind_resource' => nil,
          'params' => {},
          'target' => nil,
          'bql' => nil,
          'canonical_uri' => nil,
        }
      end
      @attributes
    end
    
    # Read only
    # @return [Source] A Source model instance describing the source associated with this URI
    def source
      @source ||= Source.find_for_uri(attributes['source'])
    end
        
    def source=(val)
      attributes['source'] = val.to_s
      @source = nil # clear cache
    end
    
    # Read only
    # @return [Kind] A Kind model instance describing the kind associated with this URI
    def kind
      @kind ||= Kind.new(attributes['kind'])
    end
    
    def kind=(val)
      attributes['kind'] = val.to_s
      @kind = nil # clear cache
    end
    
    # Uhhh... it provides some extra info for odd use cases. Rarely used.
    # i.e. Voice/SMS
    # @return [String]
    def kind_resource
      attributes['kind_resource']
    end
    
    # @param [String] Set the resource kind for this URI
    def kind_resource=(val)
      attributes['kind_resource'] = val
      # recompose_uri
    end
    
    # @return [Hash] Any querystring parameters for this URI
    def querystring_params
      attributes['params'] ||= {}
      # recompose_uri
    end
    
    # The target of a BackChat URI varies on context. In a twitter channel the target is
    # the username, or in an RSS feed the target is the URL of the XML document.
    # @return [String]
    def target
      attributes['target']
    end
    
    # @param [String] new target for this BackChat URI
    def target=(val)
      attributes['target'] = val
      # recompose_uri
    end
    
    def bql
      attributes["params"]["bql"] rescue nil
    end
    
    def bql=(val)
      attributes["params"] = {} if !attributes["params"]
      attributes["params"]["bql"] = val
      # recompose_uri
    end
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(escape = false)
      # escape ? URI.escape(expanded['canonical_uri']) : expanded['canonical_uri']
      recompose_uri
      attributes['canonical_uri'] || @uri_s
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
      return nil if uri_s.nil?
      
      # The URI is just the scheme, no host or path
      if uri_s.end_with?("://") || !uri_s.include?("://")
        return {
          'source' => uri_s.to_s.gsub(/:\/\/.*$/,''),
          'kind' => nil,
          'kind_resource' => nil,
          'params' => nil,
          'target' => nil,
          'bql' => nil,
          'canonical_uri' => nil,
        }
      else
        begin
          response = BackchatResource::Base.connection.get(expand_uri_uri(uri_s), BackchatResource::Base.headers)
          data = response['data'].first
          if data.is_a?(Array)
            return data.last # ["key",{data}]
          else
            return data
          end
        rescue
          puts "Error expanding URI #{uri_s}"
          attributes ||= {}
        end
      end
    end
    
    # def bql_looks_to_be_escaped?
    #   # If it has an encoded space then it's highly probable
    #   if self.bql.include?('%20') || 
    #     self.bql.include?('%2523') # double-escaped #
    #     true
    #   end
    #   false
    # end
    
    # Refresh a URI with the API expand URI endpoint, updating the URI @attributes state
    def recompose_uri
      payload = {
        :original_uri => attributes['canonical_uri'] || @uri_s,
        :target => attributes['target'],
        :params => querystring_params,
        :kind_resource => attributes['kind_resource'],
        # :source => (attributes['source'] || {})['_id'],
        # :kind => (attributes['kind'] || {})['_id']
      }
      if attributes['source'].is_a?(Hash)
        payload[:source] = attributes['source']['_id']
      else
        payload[:source] = attributes['source']
      end
      if attributes['kind'].is_a?(Hash)
        payload[:kind] = attributes['kind']['_id']
      else
        payload[:kind] = attributes['kind']
      end
      
      payload.delete_if {|key, value| value.blank? }
      if payload.blank? || !(payload.keys.include?(:source) && payload.keys.include?(:target))
        puts "recompose_uri:: Payload would be empty. #{@uri_s.inspect} #{attributes.inspect}"
        return nil
      end
      
      # begin
        response = BackchatResource::Base.connection.get(BackchatUri.compose_uri_uri(payload), BackchatResource::Base.headers)
        data = response['data']
        if data.is_a?(Array)
          attributes = data.last # ["key",{data}]
        else
          attributes = data
        end
      # rescue
      #   puts ("Could not recompose URI for #{payload.to_json}")
      # end
      # if bql_looks_to_be_escaped?
      #   self.bql = URI.unescape(self.bql)
      # # (attributes['params'] || {}).each do |k,v|
      # #   attributes['params'][k] = URI.unescape(v)
      # end
    end
    
    # # Base64 encode a string in a URL safe format
    # # @params String 
    # def self.encode_b64_urlsafe(s)
    #   encoded = [s].pack('m').tr('+/','-_').gsub("\n",'')
    # end
    # 
    # # Base64 decode a string in a URL safe format
    # # @params String base64-urlsafe encoded string to decode
    # def self.encode_b64_urlsafe(s)
    #   decoded = s.tr('-_','+/').unpack('m')[0]
    # end
    
    protected
    
    # @param [Hash] querystring params
    # @return [String] URI to the compose URI endpoint
    def self.compose_uri_uri(params)
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['compose_uri_path']}?#{params.to_query}"
    end
    
    # @param [String] URI to expand
    # @return [String] URI to the expand endpoint
    def expand_uri_uri(uri)
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}?channel=#{CGI.escape uri}"
    end
    
  end
end