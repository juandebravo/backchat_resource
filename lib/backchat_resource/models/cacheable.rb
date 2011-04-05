require 'cache'

module BackchatResource
  # Make a BackchatModel cacheable
  # Usage:
  #   include Cacheable
  #   cache :forever, :none
  module Models
    module Cacheable
      ShortCacheTimeout = 1.minute
      MediumCacheTimeout = 10.minutes
      LongCacheTimeout = 1.day
      
      @@cache = nil
      
      def self.extended(base)
        @@cache = Cache.new :expiration => LongCacheTimeout # NOTE: You can't cache longer than this
      end
      
      # Setup the cache for the model
      # @param [Symbol, Integer] duration
      # @param [Symbol] cache_scope
      def cache_api_response(options={})
        @scope_key = (options[:scope] || nil)
        @duration = (case options[:duration]
          when :forever
            nil # Cache this for the life time of the app
          when :short
            ShortCacheTimeout
          else
            if options[:duration].is_a?(Time)
              (options[:duration] - Time.now).to_i #seconds
            else
              options[:duration] #seconds
            end
          end)
      end

      # Cache a copy of data in the cache
      def cache(key, data)
        expiry = Time.now + duration
        
        @@cache["#{@scope_key}#{key}"] = {
          :expires => expiry,
          :data => data
        }
      end
      
      # @return [Boolean] Is there a cached copy?
      def cached?(key)
        @@cache.key?("#{@scope_key}#{key}") && !expired?
      end
      
      # Has the cached copy expired?
      # @note If the cache has expired it will also clear the cache
      # @param [String] hash key
      # @return [Boolean] expired
      def expired?(key)
        if @@cache["#{@scope_key}#{key}"][:expires] > Time.now
          @@cache["#{@scope_key}#{key}"] = nil
          true
        else
          false
        end
      end
      
    end
  end
end