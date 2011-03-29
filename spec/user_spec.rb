require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BackchatResource::Models::User" do
  
  include BackchatResource::Models
  
  before(:each) do   
    FakeWeb.allow_net_connect = false
  end
  
  after(:each) do
    FakeWeb.allow_net_connect = true 
    FakeWeb.clean_registry
  end
  
  it "authenticates a valid user and returns a User instance" do
    FakeWeb.register_uri(:post, 
                         %r[^http://localhost:8080/1/login.json], 
                         :body => load_web_api_fixture_file("login"),
                         :status => ["200", "OK"])
                         
    u = User.authenticate("brenda","gr33n")
    u.should_not be_nil
    u.class.should == User
    u.full_name.should == "Brenda Green"
    u.api_key.should == "BRENDA_API_KEY"
  end
  
  it "generates a random api_key for a logged in user" do
    pending
  end
  
  it "sends password reminders for non-logged in users" do
    pending
  end
  
  it "has a full name" do
    u = User.new(:first_name => "Brenda", :last_name => "Green")
    u.full_name.should == "Brenda Green"
  end
  
  it "validates the login name" do
    u = User.new(:login => '!@# invalid login $%^')
    u.valid?.should == false
    u.errors[:login].length.should == 1
  end
  
  it "humanice the login attribute" do
    u = User.new(:login => '!@# invalid login $%^', :first_name => "Brenda", :last_name => "Green")
    u.valid?
    u.errors.full_messages.should include "Login name can only contain letters, digits and underscores"
  end
  
  it "validates the presence of login, first and last name" do
    u = User.new
    u.valid?.should == false
    u.errors[:login].should include "can't be blank"
    u.errors[:first_name].should include "can't be blank"
    u.errors[:last_name].should include "can't be blank"
  end
  
end