module BackchatResource
  module Models
    class User < BackchatResource::Base
      
      # Flag as a singleton resource (see ReactiveResource) so we don't pluralise URL paths (user -> users)
      singleton
      
      attr_accessor :login, :password, :first_name, :last_name, :email
            
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
      
      has_many :streams
      has_many :channels
      has_one "plan"
      
      validates_presence_of :login
      validates_format_of :login, :with => /^\w+$/, :message => "can only contain letters, digits and underscores"
      validates_exclusion_of :login, :in => %w{ admin webmaster administrator postmaster team backchatio backchat mojolly support techsupport password passwordreset reset }, :message => "is not allowed for security reasons. Please try another."
      validates_presence_of :first_name, :last_name
      
      HUMANIZED_ATTRIBUTES = {
        :login => "Login name",
      }
      def self.human_attribute_name(params, options={})
        HUMANIZED_ATTRIBUTES[params.to_sym] || super(params, options)
      end

      def id
        @attributes["login"] || nil
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
      def streams=(urls)
        @streams ||= []
        urls = [urls] if !urls.is_a?(Array)
        urls.each do |stream_url|
          # Extract the plan name form the URL: http://localhost:8080/1/stream/slug1 => slug1
          slug = Addressable::URI.parse(stream_url).path.split("/").last
          @streams << Stream.find(slug)          
        end
      end
      
      # Ensure it's an array
      def channels
        @channels || []
      end

      # Set the channel attribute to an array of Channel models from the input URLs
      # @param {Array[Hash]} URLs of channels
      def channels=(params)
        @channels ||= []
        params.each do |hash|
          @channels << Channel.build_from_api_response(hash)
        end
      end
      
      # Get the Plan for the current user.
      # Instead of returning the plan URI attribute return a populated model instance
      # @return Plan
      def plan
        Plan.find_by_uri(attributes["plan"])
      end
      
      # Set the plan for this user
      # @param {string|Plan} params URL of a plan or a Plan object itself
      def plan=(param)
        if param.is_a?(String)
          attributes["plan"] = param
        elsif param.is_a?(Plan)
          attributes["plan"] = param.api_url
        end
      end
      
      # Ask the API to generate a 32 char random API key for the current user
      # @return [String] 32 char API key
      def generate_random_api_key!
        payload = {}
        response = connection.put("#{self.class.site}#{BackchatResource::CONFIG['api']['api_key_path']}.#{self.class.format.extension}", payload.to_query, self.class.headers)
        body = JSON.parse(response.body)
        api_key = body["api_key"]
        BackchatResource::Base.api_key = api_key
        api_key
      end
      
      # Authenticate a user and set the API key on BackchatResource::Base to the authenticated user
      # @param {String} username
      # @param {String} password
      # @return {User|nil} The User model belonging to the passed in credentials or nil if none was found
      def self.authenticate(username, password)
        payload = {
          :username => username,
          :password => password
        }
        response = connection.post("#{self.site}#{BackchatResource::CONFIG['api']['login_path']}.#{self.format.extension}", payload.to_query)
        body = JSON.parse(response.body)
        if body["data"]["api_key"]
          BackchatResource::Base.api_key = body["data"]["api_key"]
          new(body)
        else
          nil # warden expects a failure to return nil
        end
      end
      
      # Send a password reminder to the user
      # @params {String} login
      def self.send_password_reminder(login)
        payload = { :login => login }
        response = connection.post("#{self.site}#{BackchatResource::CONFIG['api']['forgotten_password_path']}.#{self.format.extension}", payload.to_query)
        body = JSON.parse(response.body)
        # TODO: What does a fail/success raise that we can return?
      end

      #
      # On user.save we need to 
      # - save the Streams objects to a different end point
      # - upgrade the Plan if it's changed
      # 
      def create
        # TODO
        super
      end
      def update
        # TODO
        super
      end
      
      private
      
      # Override the element path to match the BackChat.io API structure - the root is the user element
      # https://api.backchat.io/{API_VERS}/
      def self.element_path(id, prefix_options = {}, query_options = nil)
        "#{self.site}#{BackchatResource::CONFIG['api']['user_path']}index.#{self.format.extension}"
      end
      
    end
  end
end