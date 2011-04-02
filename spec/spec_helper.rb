$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# Put the lib into fixture/test mode
module BackchatResource; DebugEnv="test"; end

require 'rspec'
require 'fakeweb'
require 'backchat_resource'
require "fakeweb_routes"

include BackchatResource::Models

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # config goes here  
end