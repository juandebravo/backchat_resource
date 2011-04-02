FakeWeb.allow_net_connect = false          

# Load the contents of a fixture file
# @param [string] file name without extension
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

# Register mocked URLs that return static JSON file responses to web requests.
# We can then test the API in isolation.
# WARNING: Ensure the fixture files are kept up to date
FakeWeb.register_uri(:post, %r[^http://localhost:8080/1/login.json], 
                     :body => load_web_api_fixture_file("login"),
                     :status => ["200", "OK"])
FakeWeb.register_uri(:put, %r[^http://localhost:8080/1/api_key.json], 
                     :body => load_web_api_fixture_file("generate_api_key"),
                     :status => ["200", "OK"])
FakeWeb.register_uri(:post, %r[^http://localhost:8080/1/forgot.json], 
                    :body => load_web_api_fixture_file("forgot"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://localhost:8080/1/plans/index.json", 
                    :body => load_web_api_fixture_file("plans"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, %r[http://localhost:8080/1/plans/free], 
                    :body => load_web_api_fixture_file("plan_free"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, %r[http://localhost:8080/1/plans/amazon], 
                    :body => load_web_api_fixture_file("plan_amazon"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, %r[http://localhost:8080/1/streams/mojolly-crew], 
                    :body => load_web_api_fixture_file("stream_mojolly-crew"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, %r[http://localhost:8080/1/sources/index.json], 
                    :body => load_web_api_fixture_file("sources"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, %r[http://localhost:8080/1/expand_uri/], 
                    :body => load_web_api_fixture_file("expand_uri"),
                    :status => ["200", "OK"])
