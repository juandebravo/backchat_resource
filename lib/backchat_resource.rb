# This library provides an ActiveResource wrapper around the BackChat.io message streaming platform's RESTful API.
# It bridges ActiveResource's URL scheme to the BackChat.io API's URL scheme, allowing them to communicate together.
# It also implements BackChat.io's custom JSON format.
#
# Example:
#   BackchatResource::Models::Stream
#
# Copyright Mojolly Ltd, 2011
# @author Adam Burmister <adam@mojolly.com>
#
require 'rubygems'
require 'logger'
require 'yaml'
require 'reactive_resource'

# Load the configuration YML for use within the library classes
module BackchatResource
  Root = File.dirname(__FILE__)
  $:.unshift Root
  
  class << self
    attr_accessor :logger
  end
    
  # Configuration properties for BackchatResource
  CONFIG = YAML.load_file("#{BackchatResource::Root}/backchat_resource/config.yml")[defined?(DebugEnv) ? DebugEnv : "production"] if !defined?(CONFIG)
  
  # Sets up the credentials the ActiveResources will use to access the
  # BackChat.io API. Optionally takes a +logger+, which defaults to +STDOUT+.
  def self.setup(api_key, logger = nil)
    @logger = logger || Logger.new(STDOUT) 
    BackchatResource::Base.api_key = api_key
  end
end

require 'backchat_resource/string_extensions'
require 'backchat_resource/addressable'
require 'backchat_resource/backchat_json_format'
require 'backchat_resource/exceptions'
require 'backchat_resource/backchat_uri'
require 'backchat_resource/connection'
require 'backchat_resource/base'
require 'backchat_resource/models'
include BackchatResource

# Dir["#{BackchatResource::Root}/backchat_resource/*.rb"].each {|file| require file }

# Enable debugging output if configured
if BackchatResource::CONFIG["api"]["debug"]
  class ActiveResource::Connection
   def http
     http = Net::HTTP.new(@site.host, @site.port)
     http.set_debug_output $stderr
     return http
   end
  end
end