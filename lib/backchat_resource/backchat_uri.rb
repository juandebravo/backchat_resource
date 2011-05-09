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
      'params' => HashWithIndifferentAccess.new,
      'target' => nil,
      'canonical_uri' => nil,
    }
    @uri_s = nil
    
    def initialize(param={})
      if param.is_a?(String)
        @uri_s = param
        attributes = expand_uri(@uri_s)
      elsif param.is_a?(Hash)
        @uri_s = param["uri"] || param["canonical_uri"]
        attributes = (expand_uri(@uri_s) || {}).merge(param)
      elsif param.is_a?(BackchatUri)
        @uri_s = param.uri_s
        attributes = param.attributes.dup
        attributes = expand_uri(@uri_s)
      end
      
      if attributes["params"]
        bql = CGI.unescape(attributes["params"]["bql"] || "") if attributes["params"].key?("bql")
      end
    end
    
    # Make it easy to compare a URI with another URI, excluding the bql strings and shiz like that
    def id
      src = attributes["source"]["_id"] rescue ""
      tgt = attributes["target"] rescue ""
      knd = attributes["kind"]["_id"] rescue ""
      "#{src}://#{tgt}##{knd}"
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
          'params' => HashWithIndifferentAccess.new,
          'target' => nil,
          # 'bql' => nil,
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
      @uri_s = nil # clear cache
    end
    
    # Read only
    # @return [Kind] A Kind model instance describing the kind associated with this URI
    def kind
      @kind ||= Kind.new(attributes['kind'])
    end
    
    def kind=(val)
      attributes['kind'] = val.to_s
      @kind = nil # clear cache
      @uri_s = nil # clear cache
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
      @uri_s = nil # clear cache
    end
    
    # @return [Hash] Any querystring parameters for this URI
    def querystring_params
      @uri_s = nil # clear cache
      attributes['params'] ||= HashWithIndifferentAccess.new
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
      @uri_s = nil # clear cache
    end
    
    def bql
      querystring_params["bql"] rescue nil
    end
    
    def bql=(val)
      querystring_params["bql"] = val
      @uri_s = nil # clear cache
    end
    
    def canonical_uri
      attributes["canonical_uri"]
    end
    
    def canonical_uri=(val)
      attributes["canonical_uri"] = val
      @uri_s = nil # clear cache
    end
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(escape = false)
      recompose_uri
      uri = attributes['canonical_uri'] || @uri_s
      escape ? URI.escape(uri) : uri
      # attributes['canonical_uri'] || @uri_s
    end
    
    def to_s(escape = false)
      @uri_s ||= to_canonical_s(escape)
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
          # 'bql' => nil,
          'canonical_uri' => nil,
        }
      else
        # begin
          response = BackchatResource::Base.connection.get(expand_uri_uri(uri_s), BackchatResource::Base.headers)
          data = response['data'].first
          if data.is_a?(Array)
            return data.last # ["key",{data}]
          else
            return data
          end
        # rescue
        #   puts "Error expanding URI #{uri_s}"
        #   attributes ||= HashWithIndifferentAccess.new
        # end
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
      puts "1"*100
      puts "RECOMPOSING URI"
      puts "ATTRIBUTES:: " + attributes.inspect
      
      payload = {
        :original_channel => attributes['canonical_uri'] || @uri_s,
        :target => attributes['target'],
        # :params => querystring_params,
        :kind_resource => attributes['kind_resource'],
        # :source => (attributes['source'] || {})['_id'],
        # :kind => (attributes['kind'] || {})['_id']
      }
      # Copy querystring params into the payload at the root
      querystring_params.each do |k,v|
        if payload.key?(k.to_sym) == false
          payload[k.to_sym] = v
        end
      end
      if querystring_params.any?
        puts "*"*100
        puts payload.inspect 
      end
      
      # Set source
      if attributes['source'].is_a?(Hash)
        payload[:source] = attributes['source']['_id']
      else
        payload[:source] = attributes['source']
      end
      # Set kind
      if attributes['kind'].is_a?(Hash)
        payload[:kind] = attributes['kind']['_id']
      else
        payload[:kind] = attributes['kind']
      end
      
      # puts "PAYLOAD:: " + payload.inspect
      
      payload.delete_if {|key, value| value.blank? }
      if payload.blank? || !(payload.keys.include?(:source) && payload.keys.include?(:target))
        puts "recompose_uri:: Payload would be empty. #{attributes.inspect}"
        return nil
      end
      # puts "^"*100
      
      # begin
        response = BackchatResource::Base.connection.get(BackchatUri.compose_uri_uri(payload), BackchatResource::Base.headers)
        data = response['data']
        if data.is_a?(Array)
          @attributes = data.last # ["key",{data}]
        else
          @attributes = data
        end
        
        puts @attributes.inspect
        
        puts "2"*100
        
        @attributes
      # rescue
      #   puts ("Could not recompose URI for #{payload.to_json}")
      # end
      # if bql_looks_to_be_escaped?
      #   self.bql = URI.unescape(self.bql)
      # # (attributes['params'] || {}).each do |k,v|
      # #   attributes['params'][k] = URI.unescape(v)
      # end
    end
    
    protected
    
    # @param [Hash] querystring params
    # @return [String] URI to the compose URI endpoint
    def self.compose_uri_uri(params)
      qs = params.to_query#.gsub!('[]','') # Backend expects arrays to be multiple values 'name=foo&name=bar', not 'name[]'
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['compose_uri_path']}?#{qs}"
    end
    
    # @param [String] URI to expand
    # @return [String] URI to the expand endpoint
    def expand_uri_uri(uri)
      "#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}?channel=#{CGI.escape uri}"
    end
    
  end
end