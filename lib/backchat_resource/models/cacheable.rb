# require 'cache'

module BackchatResource
  # Make a BackchatModel cacheable
  # Usage:
  #   include Cacheable
  #   cache :forever, :none
  module Models
    module Cacheable
      
      # @lru_cache = nil
      # @scope_key = nil
      
      def self.extended(base)
        # @lru_cache = Cache.new
      end

      # # Setup the cache for the model
      # # @param [Symbol, Integer] duration
      # # @param [Symbol] cache_scope
      # def cache_api_response(duration, options={})
      #   @scope_key = (case options[:scope]
      #   when :user
      #     self.class.api_key
      #   else #everyone
      #     nil
      #   end)
      #   
      #   @lru_cache.expiration (case duration
      #   when :forever
      #     nil # Cache this for the life time of the app
      #   else
      #     if duration.is_a?(Integer)
      #       duration #seconds
      #     elsif duration.is_a?(Time)
      #       (duration - Time.now).to_i #seconds
      #     end
      #   end)
      # end
      
    end
  end
end