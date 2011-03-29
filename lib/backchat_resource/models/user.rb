module BackchatResource
  module Models
    class User < BackchatResource::Base      
      
      self.site = BackchatResource::CONFIG["api"]["host"].gsub(/\/(\d+)\/$/,'')
      api_version = BackchatResource::CONFIG["api"]["host"].match(/\/(\d+)\/$/)[1]
      self.element_name = api_version
      self.collection_name = api_version
      
      schema do
        string '_id',
               'email',
               'login',
               'first_name',
               'last_name',
               'date_of_birth',
               'gender',
               'postcode',
               'language',
               'timezone',
               'country',
               'api_key'
        # Unsupported types are left as strings
        string 'plan',
               'streams',
               'channels'
      end   
      
      attr_accessor :plan, :streams, :channels
      
      validates_presence_of :login
      validates_format_of :login, :with => /^\w+$/, :message => "can only contain letters, digits and underscores"
      validates_exclusion_of :login, :in => %w{ admin backchatio backchat mojolly support techsupport password passwordreset reset }, :message => "is not allowed for security reasons. Please try another."
      validates_presence_of :first_name, :last_name
      
      # Humanize the target attribute
      HUMANIZED_ATTRIBUTES = {
        :login => "Login name",
      }
      def self.human_attribute_name(params, options={})
        HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
      end
      
      # Helper to return the fullname of this user
      def full_name
        "#{first_name} #{last_name}".strip
      end
      
      # Ensure it's an array
      def streams
        @streams || []
      end
      
      # Set the streams attribute to an array of Stream models from the input URLs
      # @param {Array[string]} URLs to stream descriptions
      def streams=(array_of_url)
        puts "&"*100
        puts array_of_url.inspect
        @streams = array_of_url
      end
      
      # Ensure it's an array
      def channels
        @channels || []
      end
      
      # Set the plan attribute to a Plan model by a URL to the plan on the API
      # @param {String} plan_url
      def plan=(plan_url)
        # Extract the plan name form the URL:
        # http://localhost:8080/1/plans/free => free
        plan_name = plan_url.match(%r[/plans/(.*)$])[1]
        @plan = Plan.find(plan_name)
      end
      
      # Ask the API to generate a 32 char random API key for the current user
      # @return [String] 32 char API key
      def generate_random_api_key!
        response = put(BackchatResource::CONFIG['api']['api_key_path'])
        params = JSON.parse(response.body)
        api_key = params["api_key"]
        BackchatResource::Base.api_key = api_key
        api_key
      end
      
      # Authenticate a user
      # @param {String} username
      # @param {String} password
      # @return {User|nil} The User model belonging to the passed in credentials or nil if none was found
      def self.authenticate(username, password)
        auth_params = {
          :username => username,
          :password => password
        }
        response = post(BackchatResource::CONFIG['api']['login_path'], auth_params)
        params = JSON.parse(response.body)
        puts params.inspect
        BackchatResource::Base.api_key = params["data"]["api_key"]
        new(params)
      end
      
      # Send a password reminder to the user
      # @params {String} login
      def self.send_password_reminder(login)
        data = post(BackchatResource::CONFIG['api']['forgotten_password_path'], { :login => login })
      end
      
      private
      
      # https://github.com/rails/rails/blob/3-0-4-security/activeresource/lib/active_resource/custom_methods.rb#L110
      # Customise the URLs to use for requesting stuff associated with the user.
      # User object calls are at the API root, 'https://api.backchat.io/1/'
      def custom_method_element_url(method_name, options = {})
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{method_name}.#{self.class.format.extension}#{self.class.__send__(:query_string, options)}"
      end
      
      def custom_method_new_element_url(method_name, options = {})
        "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{method_name}/new.#{self.class.format.extension}#{self.class.__send__(:query_string, options)}"
      end
      
    end
  end
end