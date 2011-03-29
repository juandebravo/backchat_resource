$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fakeweb'
require 'backchat_resource'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

# Load the contents of a fixture file
# @param {String} file name without extension
def load_web_api_fixture_file(name)
  path = File.join(File.dirname(__FILE__), 'fixtures', "#{name}.json")
  if File.exists?(path)
    contents = ""
    File.open(path).each do |line|
      contents << line
    end
    return contents
  else
    return nil
  end      
end