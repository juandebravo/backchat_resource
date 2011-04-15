module BackchatResource
  module Models
    module Channels
      class EmailDropbox < BackchatResource::Models::Channels::Generic
        
        attr_accessor :whitelist
        
        HUMANIZED_ATTRIBUTES = {
          :target => "Dropbox email address"
        }
        def self.human_attribute_name(params, options={})
          HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
        end

        validates :target, :presence => true, :format => { :with => /^[a-zA-Z0-9\-+_]+$/ }
        
        def display_target
          "#{target}@backchat.io"
        end
        
        def target=(val)
          super(val.to_slug)
        end

        def whitelist
          if uri.querystring_params["whitelist"]
            @whitelist = uri.querystring_params["whitelist"]
            @whitelist = @whitelist.split(",")
          end
          @whitelist || []
        end

        # Set the whitelist in the URI
        # @param [String]
        def whitelist=(lst)
          uri.querystring_params["whitelist"] = lst.split(",").map(&:strip).reject{|e|e.blank?}
        end
   
        
      end
    end
  end
end