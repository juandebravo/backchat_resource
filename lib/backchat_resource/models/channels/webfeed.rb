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

        # Ensure the URI includes HTTP
        def target=(url)
          # Set the resources on the URI
          url = url.match(/^https?:\/\//) ? url : "http://#{url}"
          url = Addressable::URI.parse(url)
          self.old_uri = url.to_s # http://something.com/something
          self.uri.querystring_params["resources[]"] = url.path # /something
          super url.host # something.com
        end
                  
        def must_be_url
          begin
            Addressable::URI.parse(self.target)
          rescue
            errors.add("target", "isn't valid")
          end
        end

      end
    end
  end
end