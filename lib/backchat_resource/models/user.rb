module BackchatResource
  module Models
    class User < BackchatResource::Base      
      # @see ReactiveResource
      # Flag as a singleton resource so we don't pluralise URL paths (user -> users)
      singleton
      
      # The schema doesn't seem to be setting up attribute readers for us
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
      
      # @return the full name of this user
      def full_name
        "#{first_name} #{last_name}".strip
      end
      
      # :nodoc:
      # Ensure it's an array
      def streams
        @streams || []
      end
      
      # Set the streams attribute to an array of Stream models from the input URLs
      # @param [Array<string>] URLs to stream descriptions
      def streams=(urls)
        @streams ||= []
        urls = [urls] if !urls.is_a?(Array)
        urls.each do |stream_url|
          # Extract the plan name form the URL: http://localhost:8080/1/stream/slug1 => slug1
          slug = stream_url.split("/").last
          @streams << Stream.find(slug)          
        end
      end
      
      # :nodoc:
      # Ensure it's an array
      def channels
        @channels || []
      end

      # Set the `channels` attribute to an array of Channel models from the input URLs
      # @param [Array<Hash>] URLs of channels
      def channels=(params)
        @channels ||= []
        params.each do |hash|
          @channels << Channel.build_from_uri(hash)
        end
      end
      
      # Get the Plan for the current user.
      # Instead of returning the plan URI attribute return a populated model instance
      # @return Plan
      def plan
        @plan ||= Plan.get_from_url(attributes["plan"])
      end
      
      # Set the plan for this user
      # @param {string|Plan} params URL of a plan or a Plan object itself
      def plan=(param)
        if param.is_a?(String)
          attributes["plan"] = param
        elsif param.is_a?(Plan)
          attributes["plan"] = param.api_url
        end
        @plan = nil # clear cache
      end
      
      # Find a channel within the current users channels collection that matches the `uri` param
      # @param [URI, string]
      # @return [Array<Channel>]
      def find_channels_for_uri(uri)
        uri = BackchatUri.parse(uri) if uri.is_a?(String)
        results = []
        channels.each do |ch|
          results << ch if ch.uri.to_bare_s == uri.to_bare_s
        end
        results
      end
      
      # Find all streams that reference the passed channel within the current user's scope
      # @param [Channel] channel to search for in streams
      # @return [Array<Stream>] matching streams
      def find_streams_using_channel(ch)
        return [] if ch.nil?
        results = []
        channel_uri = ch.uri.to_bare_s
        streams.each do |strm| 
          strm.channel_filters.each do |cf|
            if cf.uri.to_bare_s == channel_uri
              results << cf
            end
          end
        end
        results
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
      # @param [string] username
      # @param [string] password
      # @return {User|nil} The User model belonging to the passed in credentials or nil if none was found
      def self.authenticate(username, password)
        begin
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
        rescue ActiveResource::UnauthorizedAccess
          nil
        end
      end
      
      # Send a password reminder to the user
      # @param [string] login
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