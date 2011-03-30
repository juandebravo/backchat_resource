# Register mocked URLs that return static JSON file responses to web requests.
# We can then test the API in isolation.
# WARNING: Ensure the fixture files are kept up to date
FakeWeb.register_uri(:post, %r[^http://localhost:8080/1/login.json], 
                     :body => load_web_api_fixture_file("login"),
                     :status => ["200", "OK"])
FakeWeb.register_uri(:put, %r[^http://localhost:8080/1/api_key.json], 
                     :body => load_web_api_fixture_file("api_key"),
                     :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://localhost:8080/1/plans/index.json", 
                    :body => load_web_api_fixture_file("plans"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://localhost:8080/1/plans/free.json", 
                    :body => load_web_api_fixture_file("free_plan"),
                    :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://localhost:8080/1/streams/mojolly-crew.json", 
                    :body => load_web_api_fixture_file("mojolly-crew"),
                    :status => ["200", "OK"])