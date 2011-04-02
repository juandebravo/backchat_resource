require 'active_resource'

module ActiveResource
  # Class to handle connections to remote web services.
  # This class is used by BackchatResource::Base to interface with REST
  # services.
  # It overrides the ActiveResource::Connection class to add in an extra
  # caching layer, reducing needless requests to the BackChat.io API.
  class Connection

    private
    
      alias_method :old_request, :request
      # Makes a request to the remote service.
      def request(method, path, *arguments)
        # TOOD: Return cached response if available
        old_request(method, path, *arguments)
      end

      alias_method :old_handle_response, :handle_response
      # Handles response and error codes from the remote service.
      def handle_response(response)
        result = old_handle_response(response)
        
        # TODO: cache the response
        # case response.code.to_i
        #   when 301,302
        #     # raise(Redirection.new(response))
        #   when 200...400
        #     # response
        #   when 400
        #     # raise(BadRequest.new(response))
        #   when 401
        #     # raise(UnauthorizedAccess.new(response))
        #   when 403
        #     # raise(ForbiddenAccess.new(response))
        #   when 404
        #     # raise(ResourceNotFound.new(response))
        #   when 405
        #     # raise(MethodNotAllowed.new(response))
        #   when 409
        #     # raise(ResourceConflict.new(response))
        #   when 410
        #     # raise(ResourceGone.new(response))
        #   when 422
        #     # raise(ResourceInvalid.new(response))
        #   when 401...500
        #     # raise(ClientError.new(response))
        #   when 500...600
        #     # raise(ServerError.new(response))
        #   else
        #     # raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
        # end
        
        result
      end

  end
end