module BackchatResource
  module Models
    module Channels
      class Webfeed < BackchatResource::Models::Channels::Generic

        HUMANIZED_ATTRIBUTES = {
          :target => "Webfeed URL"
        }
        def self.human_attribute_name(params, options={})
          HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
        end

        validate :must_be_url
        def must_be_url
          begin
            Addressable::URI.parse(self.target)
          rescue
            errors.add("target", "isn't valid")
          end
        end
        
        def target
          self.uri.to_s
        end

        # Ensure the URI includes HTTP
        def target=(url)
          # Set the resources on the URI
          # Ensure the URL starts with http:// or https:// for parsing purposes
          url = url.match(/^https?:\/\//) ? url : "http://#{url}"
          url = Addressable::URI.parse(url)
          # Store a ref to the old URL
          self.old_uri = url.to_s # http://something.com/something
          # Set the resources collection to be the path on the URL
          self.uri.querystring_params["resources[]"] = url.path # /something
          # Set the target to be the domain
          super url.host # something.com
        end
      
      end
    end
  end
end