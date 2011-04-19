require 'active_resource/exceptions'

module ActiveResource
  # Active Resource validation is reported to and from this object, which is used by Base#save
  # to determine whether the object in a valid state to be saved. See usage example in Validations.
  class Errors < ActiveModel::Errors
    # Grabs errors from an array of messages (like ActiveRecord::Validations)
    # The second parameter directs the errors cache to be cleared (default)
    # or not (by passing true)
    def from_backchat_array(messages, save_cache = false)
      clear unless save_cache
      humanized_attributes = @base.attributes.keys.inject({}) { |h, attr_name| h.update(attr_name.humanize => attr_name) }
      
      # If an error occurs on these keys then add it to the base
      base_keys = [:channel]
      
      messages.each do |message|
        if message.length == 1 # message only
          self[:base] << err[0]
        else #key, message(*)
          key = message[0].to_sym
          
          key = :base if base_keys.include?(key)
          
          message[1..-1].each do |value|
            add(key, value)
          end
        end
      end
    end
    
    # Grabs errors from a json response.
    def from_backchat_json(json, save_cache = false)
      array = Array.wrap(ActiveSupport::JSON.decode(json)['errors']) rescue []
      from_backchat_array array, save_cache
    end
  end
  
  module Validations
    # Loads the set of remote errors into the object's Errors based on the
    # content-type of the error-block received
    def load_remote_errors(remote_errors, save_cache = false ) #:nodoc:
      case self.class.format
      when ActiveResource::Formats[:xml]
        errors.from_xml(remote_errors.response.body, save_cache)
      when ActiveResource::Formats[:json]
        errors.from_json(remote_errors.response.body, save_cache)
      when ActiveResource::Formats::BackchatJsonFormat
        errors.from_backchat_json(remote_errors.response.body, save_cache)
      end
    end
  end
end

module BackchatResource                
  class Base < ReactiveResource::Base
    # include ActiveModel::Dirty
    
    self.site   = BackchatResource::CONFIG["api"]["host"]
    self.format = :backchat_json
    self.timeout = BackchatResource::CONFIG["api"]["timeout"] || 5
    self.include_root_in_json = false

    cattr_accessor :api_key
    
    # Some of our resources don't have IDs, so this allows us to mark them as new/existing for PUT/POST methods
    @is_new_record = false
    def new?
      @is_new_record || id.nil?
    end
    def is_new=(val)
      @is_new_record = val
    end
    
    # def encode(options={})
    #   self.class.format.encode(attributes, options)
    # end
    def encode(options={})
      send("to_#{self.class.format.extension}", options)
    end
            
    # Builds a new, unsaved record using the schema.
    def build(attributes = {})
      # attrs = self.format.decode(connection.get("#{new_element_path}").body).merge(attributes)
      attrs = self.schema
      raise attrs.inspect
      self.new(attrs)
    end
        
    # https://github.com/rails/rails/blob/master/activeresource/lib/active_resource/base.rb#L1235
    # Load attributes into a class instance from a BackChat.io API JSON response document
    # which looks like { 'data': {}, 'errors': {} }
    def load(attributes)
      raise ArgumentError, "expected an attributes Hash, got #{attributes.inspect}" unless attributes.is_a?(Hash)
      @prefix_options, attributes = split_options(attributes)
      # Accept both a Hash of attributes and a hash of :data and :error attributes
      errors = attributes.key?(:errors) ? attributes[:errors] : []
      data   = attributes.key?(:data)   ? attributes[:data]   : attributes
      # Load the data attributes hash into the model
      data.each do |key, value|
        @attributes[key.to_s] =
          case value
            when Array
              resource = find_or_create_resource_for_collection(key)
              value.map do |attrs|
                if attrs.is_a?(Hash)
                  resource.new(attrs)
                else
                  attrs.duplicable? ? attrs.dup : attrs
                end
              end
            when Hash
              resource = find_or_create_resource_for(key)
              resource.new(value)
            else
              value.dup rescue value
          end
        # ADDED - Call the attribute writer method
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
        # END ADD
      end
      self
    end
        
    # # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations.rb#L176
    # # Check if a AR model instance is valid.
    # # In the AR code it clears the errors Hash every time it runs this. This means it would clear any errors
    # # that have been added from the JSON document. So, this method is overriden to check the JSON doc's errors
    # # are empty in addition to the AR validators passing.
    # def valid?(context = nil)
    #   current_context, self.validation_context = validation_context, context
    #   errors.clear
    #   run_validations! && errors.blank?
    # ensure
    #   self.validation_context = current_context
    # end
    
    # Add errors from an AR web exception to the base of the model
    def add_errors_from_response_exception(e)
      return if !e.respond_to?(:response)
      errors = (BackchatResource::Base.format.decode(e.response.body))["errors"]
      if errors.any?
        errors.each do |err|
          if err.length == 1 # message only
            self.errors.add(:base, err[0])
          else #key, message(*)
            key = err[0].to_sym
            err[1..-1].each do |value|
              self.errors.add(key, value)
            end
          end
        end
      end
    end
    
    class << self
      
      # Return the BackChat.io Authorization header with the API key for the user in place
      def headers
        @headers ||= { "Authorization" => "Backchat #{@@api_key}" }
      end
      
      # Change the collection path to be index.json, rather than collection_name.json
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}/index.#{format.extension}#{query_string(query_options)}"
      end

      # Instantiate a collection document from BackChat.io API
      # This document should contain a "data" array element with attributes for each record
      def instantiate_collection(collection, prefix_options = {})
        if collection.is_a?(Hash) && collection.key?("data") && collection["data"].kind_of?(Array)
          records = []
          errors  = collection["errors"] || []
          collection["data"].each do |record|
            record_hash = { :data => record, :errors => errors }  # Massage the data into the expected format
            records << instantiate_record(record_hash, prefix_options)
          end
          records
        else
          collection.collect! { |record| instantiate_record(record, prefix_options) }
        end
      end
  
    end
  end
end
