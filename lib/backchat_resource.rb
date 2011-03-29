# Copyright Mojolly Ltd, 2011
# @author Adam Burmister <adam@mojolly.com>
# This library provides an ActiveResource wrapper around the BackChat.io message streaming platform's RESTful API.
# It bridges ActiveResource's URL scheme to the BackChat.io API's URL scheme, allowing them to communicate together.
# It also implements BackChat.io's custom JSON format.
#
# Example:
#   BackchatResource::Models::Stream
require 'yaml'

# Load the configuration YML for use within the library classes
module BackchatResource
  Root = File.dirname(__FILE__)
  $:.unshift Root
  
  CONFIG = YAML.load_file("#{BackchatResource::Root}/backchat_resource/config.yml")[(Rails.env rescue "development")] if !defined?(CONFIG)
end

Dir["#{BackchatResource::Root}/backchat_resource/*.rb"].each {|file| require file }
Dir["#{BackchatResource::Root}/backchat_resource/models/*.rb"].each {|file| require file }
