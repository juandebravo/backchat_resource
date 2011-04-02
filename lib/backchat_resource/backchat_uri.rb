# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class BackchatUri
    
    # BACKCHAT_URI_REGEX = /^(([^:\/\?#]+):\/\/)?((.*):(.*)@)?([^?#\/:]*)(:(\d*))?(\/([^?#]*))?(\?([^#]*))?(#([^\/]*))?(\/(.*))?/
    
    # DOWNCASED_ATTRIBUTES = %w{scheme kind}
    
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
    
    # # Returns the URI in the full form. Full has all possible information on it
    # # @example scheme://(user:secret@):source/resource#channel/path
    # # @return string full URI
    # def to_full_s(options={ :escape_hash => false })
    #   cred = resource = kind = nil
    # 
    #   cred        = "#{self.encode_b64_urlsafe(@expanded[:user])}:#{self.encode_b64_urlsafe(@expanded[:password])}@"  if @expanded[:user]
    #   source      = @expanded[:source]
    #   source      = "#{source}:#{@expanded[:port]}"      if @expanded[:port]
    #   resource    = "/#{@expanded[:resource]}"           if @expanded[:resource]
    #   querystring = "?#{@expanded[:querystring]}"        if @expanded[:querystring]
    #   kind        = "##{@expanded[:kind]}"               if @expanded[:kind]
    #   resource_fr = "/#{@expanded[:fragment_resource]}"  if @expanded[:fragment_resource]
    # 
    #   full_uri    = "#{@expanded[:scheme]}://#{cred}#{source}#{resource}#{querystring}#{kind}#{resource_fr}"
    #   full_uri.gsub!("#","%23") if options[:escape_hash]
    # 
    #   full_uri
    # end
    
    # Returns the URI in the canonical form. Canonical has everything but credentials
    # @example scheme://source/resource#channel/path
    # @return string canonical URI
    def to_canonical_s(options={ :escape_hash => false })
      cred = resource = kind = nil
    
      source      = @expanded[:source]
      source      = "#{source}:#{@expanded[:port]}"      if @expanded[:port]
      resource    = "/#{@expanded[:resource]}"           if @expanded[:resource]
      querystring = "?#{@expanded[:querystring]}"        if @expanded[:querystring]
      kind        = "##{@expanded[:kind]}"               if @expanded[:kind]
      resource_fr = "/#{@expanded[:fragment_resource]}"  if @expanded[:fragment_resource]
    
      canonical_uri = "#{@expanded[:scheme]}://#{source}#{resource}#{kind}#{resource_fr}"
      canonical_uri.gsub!("#","%23") if options[:escape_hash]
    
      canonical_uri
    end
    
    # # Returns the URI in the bare form.
    # # @example scheme://source/resource
    # # @return string canonical URI
    # def to_bare_s(options={ :escape_hash => false })
    #   cred = resource = kind = nil
    # 
    #   source      = @expanded[:source]
    #   source      = "#{source}:#{@expanded[:port]}"      if @expanded[:port]
    # 
    #   bare_uri    = "#{@expanded[:scheme]}://#{source}"
    #   bare_uri.gsub!("#","%23") if options[:escape_hash]
    # 
    #   bare_uri
    # end
    
    # def inspect
    #   "#<BackchatUri:#{as_full}>"
    # end
    
    def to_s
      to_canonical_s
    end
    
    # Provide bcuri.host, etc
    def method_missing(method, *args, &block)  
      if @expanded
        if @expanded.key?(method)
          return @expanded[method]
        end
        m = method.to_s
    
        if method.id2name =~ /(.+)=/ && (part = Regexp.last_match(1).to_sym) && @expanded.key?(part)
          val = args[0]
          @expanded.merge!( part => val )
          return 
        end
      end
      super
    end
    
    protected
    
    # Parse a BackchatUriString into a hash
    # Attributes are downcased later on in the life cycle. See DOWNCASED_ATTRIBUTES
    # @params String uri_s
    def self.parse(uri_s)
      new(expand_uri(uri_s))
    end
    
    def self.expand_uri(uri_s)
      # uri = URI.unescape(uri_s)
      p = {}
      
      response = BackchatResource::Base.connection.get("#{BackchatResource::Base.site}#{BackchatResource::CONFIG['api']['expand_uri_path']}")
      JSON.parse(response.body)
      
      # r = BACKCHAT_URI_REGEX.match(uri)

      # p[:scheme]      = r[2]
      #       p[:user]        = r[4]
      #       p[:password]    = r[5]
      #       p[:source]      = r[6]
      #       p[:port]        = r[8]
      #       p[:resource]    = r[10]
      #       p[:resources]   = nil
      #       p[:querystring] = r[12]
      #       p[:query]       = nil
      #       p[:kind]        = r[14]
      #       p[:fragment_resource] = r[16]
      # 
      #       # Break up the querystring and resource strings into more usable data structures
      #       if p[:resource]
      #         p[:resources] = p[:resource].split("/").reject(&:empty?)
      #       end
      # 
      #       # Break up the querystring into kvp
      #       if p[:querystring]
      #         # bql=something => pairs["bql=something"]
      #         pairs = [ p[:querystring] ]
      # 
      #         # bql=something&alt=something => pairs["bql=something","alt=something"]
      #         if p[:querystring].index("&")
      #           pairs = p[:querystring].split("&")
      #         end
      # 
      #         # Build up { "bql" => "something", "alt" => "something" }
      #         kvp = {}
      #         pairs.each do |pair|
      #           t = pair.split("=")
      #           kvp.merge!({ t[0] => t[1] })
      #         end
      # 
      #         p[:query] = kvp
      # 
      #         # Allow for alternative username and password syntax
      #         # ex: xmpp://xmpp.mojolly.com/adium?user=ivan@mojolly.com&pass=password#muc/room
      #         p[:user]        = p[:query]["user"] if p[:query].key?("user")
      #         p[:password]    = p[:query]["pass"] if p[:query].key?("pass")
      #       end
      # 
      #       # Tidy up some formatting
      #       p[:port]        = p[:port].to_i if p[:port]
      #       p[:querystring] = URI.escape(p[:querystring]) if p[:querystring]
      
      
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
    
  end
end