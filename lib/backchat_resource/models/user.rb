module BackchatResource
  module Models
    class User < BackchatResource::Base      
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
      
      # Ask the API to generate a 32 char random API key for the current user
      # @return [String] 32 char API key
      def generate_random_api_key!
        data = RestModel.put(BackchatResource::CONFIG['api']['api_key_path'])
        api_key = data["api_key"]
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
        data = post(BackchatResource::CONFIG['api']['login_path'], auth_params)
        RestModel.api_key = data["api_key"]
        new(data)
      end
      
      # Send a password reminder to the user
      # @params {String} login
      def self.send_password_reminder(login)
        data, @errors = post(BackchatResource::CONFIG['api']['forgotten_password_path'], { :login => login })
      end
         
    end
  end
end