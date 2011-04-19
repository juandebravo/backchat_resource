require 'active_resource'
require 'cache'

module ActiveResource
  # Class to handle connections to remote web services.
  # This class is used by BackchatResource::Base to interface with REST
  # services.
  # It overrides the ActiveResource::Connection class to add in an extra
  # caching layer, reducing needless requests to the BackChat.io API.
  class Connection
    
    ShortCacheTimeout = 60 # seconds
    
    @@cache = Cache.new :expiration => ShortCacheTimeout
    
    private
    
      # def handle_response(response)
      #   case response.code.to_i
      #     when 301,302
      #       raise(Redirection.new(response))
      #     when 200...400
      #       response
      #     when 400
      #       raise(BadRequest.new(response))
      #     when 401
      #       raise(UnauthorizedAccess.new(response))
      #     when 403
      #       raise(ForbiddenAccess.new(response))
      #     when 404
      #       raise(ResourceNotFound.new(response))
      #     when 405
      #       raise(MethodNotAllowed.new(response))
      #     when 409
      #       raise(ResourceConflict.new(response))
      #     when 410
      #       raise(ResourceGone.new(response))
      #     when 422
      #       raise(ResourceInvalid.new(response))
      #     when 401...500
      #       raise(ClientError.new(response))
      #     when 500...600
      #       raise(ServerError.new(response))
      #     else
      #       raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
      #   end
      # end
      
      alias_method :old_request, :request
      # Makes a request to the remote service.
      def request(method, path, *arguments)
        if (BackchatResource::CONFIG["api"]["cache"] || false)
          cache_key = cache_key(method, path, *arguments)
          
          user_uri = URI.parse(User.element_path)
          user_path_regex = Regexp.new(user_uri.path)        
          login_uri = URI.parse(User.login_path)
          login_path_regex = Regexp.new(login_uri.path)

          if method == :get && !(login_path_regex =~ path || user_path_regex =~ path)
            if @@cache.cached?(cache_key)
              return @@cache[cache_key]
            else
              # It's not yet cached
              response = old_request(method, path, *arguments)
              case response.code.to_i
                when 200...400
                  @@cache[cache_key] = response
              end
              return response
            end
          else
            # PUT/POST/DELETE
            # If not a get we're modifying data, so remove the cached copy
            # puts "Deleting cache #{cache_key}" if @@cache.cached?(cache_key)
            @@cache.delete(cache_key) if @@cache.cached?(cache_key)
          end
        end

        return old_request(method, path, *arguments)
      end
      
      def cache_key(method, path, *arguments)
        rejected_keys = %w{Accept accept-encoding}
        params = ""
        arguments.each do |args|
          if args.is_a?(Hash)
            args.delete_if { |key,value| rejected_keys.include?(key) }
        
            sorted_keys = args.keys.sort
            sorted_keys.each do |key|
              params += "_#{key}=#{args[key]}"  
            end
          elsif args.is_a?(String)
            params += "_#{args}"
          end
        end
        uri = URI.parse(path)
        URI.escape("#{uri.path}?#{uri.query}_#{params}")
      end
  end
end