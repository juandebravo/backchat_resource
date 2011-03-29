# Copyright Mojolly Ltd, 2011
# @author Adam Burmister <adam@mojolly.com>
# This library provides an ActiveResource wrapper around the BackChat.io message streaming platform's RESTful API.
# It bridges ActiveResource's URL scheme to the BackChat.io API's URL scheme, allowing them to communicate together.
# It also implements BackChat.io's custom JSON format.
#
# Example:
#   BackchatResource::Models::Stream

require 'rubygems'
require 'yaml'
require "addressable/uri"

# Load the configuration YML for use within the library classes
module BackchatResource
  Root = File.dirname(__FILE__)
  $:.unshift Root
  
  # Configuration properties for BackchatResource
  CONFIG = YAML.load_file("#{BackchatResource::Root}/backchat_resource/config.yml")[(Rails.env rescue "development")] if !defined?(CONFIG)
end

Dir["#{BackchatResource::Root}/backchat_resource/*.rb"].each {|file| require file }
Dir["#{BackchatResource::Root}/backchat_resource/models/*.rb"].each {|file| require file }

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