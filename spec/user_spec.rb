require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "fakeweb_routes"

describe BackchatResource::Models::User.to_s do
  
  it "authenticates a valid user and returns a User instance" do                         
    u = User.authenticate("brenda","gr33n")
    u.should_not be_nil
    u.class.should == User
    u.full_name.should == "Brenda Green"
    u.api_key.should == "BRENDA_API_KEY"
  end
  
  it "generates a random api_key for a logged in user" do
    u = User.authenticate("brenda","gr33n")
    old_api_key = u.api_key
    u.generate_random_api_key!
    u.api_key.should_not == old_api_key
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
  
  it "should have a plan" do
    u = User.authenticate("brenda","gr33n")
    u.plan.should be_an_instance_of Plan
  end
  
  it "should have a streams array" do
    u = User.authenticate("brenda","gr33n")
    u.streams.should be_an_instance_of Array
  end
  
  it "should have a channels array" do
    u = User.authenticate("brenda","gr33n")
    u.channels.should be_an_instance_of Array
  end
  
  it "can save changes" do
    pending
  end
  
  it "should allow the plan to be changed" do
    pending
  end
  
  it "should raise server validation errors if data is invalid" do
    pending
  end
  
end