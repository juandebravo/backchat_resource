module BackchatResource
  module Models
    module Channels
      class EmailDropbox < BackchatResource::Models::Channels::Generic
        
        HUMANIZED_ATTRIBUTES = {
          :target => "Dropbox email address"
        }
        def self.human_attribute_name(params, options={})
          HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
        end

        def display_target
          "#{self.target}@backchat.io"
        end
        
        def dropbox_name
          "#{target}@backchat.io"
        end
        
      end
    end
  end
end