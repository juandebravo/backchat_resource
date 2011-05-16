module BackchatResource
  module Models
    module Channels
      class EmailDropbox < BackchatResource::Models::Channels::Generic
        
        attr_accessor :whitelist, :user_login
        
        HUMANIZED_ATTRIBUTES = {
          :target => "Dropbox email address"
        }
        def self.human_attribute_name(params, options={})
          HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
        end

        # validates :target, :presence => true, :format => { :with => /^[a-zA-Z0-9\-+_].[a-zA-Z0-9\-+_]+$/ }
        
        def display_target
          "#{target}@backchat.io"
        end
        
        # Add in the user_login name
        def target=(val)
          # if val[0..user_login.length] != "#{user_login}."
          val = "#{user_login}.#{val}"
          # end
          
          super(val.to_slug)
        end
        
        # Strip out the user_login name from the target for editing
        def target
          tgt = super
          tgt.gsub(/^.*\./, '') if !tgt.nil?
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