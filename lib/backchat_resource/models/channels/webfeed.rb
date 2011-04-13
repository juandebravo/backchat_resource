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
        # 
        # def target=(url)
        #   super(url.gsub("http://",""))
        # end
                  
        def must_be_url
          # puts 'v' * 100
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