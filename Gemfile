source "http://rubygems.org"

gem "activeresource"#, ">= 3.0.6"
gem "unidecode"
gem "addressable"
gem "reactive_resource", :git => "git://github.com/justinweiss/reactive_resource.git"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec", "~> 2.3.0"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.5.2"
  gem "rcov", ">= 0"
	gem "autotest" 
	gem "autotest-fsevent" if `uname -s` =~ /Darwin/
	gem "fakeweb"
	gem "fuubar"
	gem "yard"
end