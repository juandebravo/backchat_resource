require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "fakeweb_routes"

describe BackchatResource::Models::User.to_s do

  TEST_USER = "brenda"
  TEST_PASS = "gr33n"
  
  before(:each) do
    @user = User.authenticate(TEST_USER,TEST_PASS)
  end
  
  it "authenticates a valid user and returns a User instance" do                         
    @user.should_not be_nil
    @user.class.should == User
    @user.full_name.should == "Brenda Green"
    @user.api_key.should == "BRENDA_API_KEY"
  end
  
  it "generates a random api_key for a logged in user" do
    old_api_key = @user.api_key
    @user.generate_random_api_key!
    @user.api_key.should_not == old_api_key
  end
  
  it "sends password reminders for non-logged in users" do
    User.send_password_reminder(TEST_USER)
  end
  
  it "has a full name" do
    @user.full_name.should == "Brenda Green"
  end
  
  it "validates the login name" do
    u = User.new(:login => '!@# invalid login $%^')
    u.valid?.should == false
    u.errors[:login].length.should == 1
  end
  
  it "humanice the login attribute" do
    u = User.new(:login => '!@# invalid login $%^', :first_name => TEST_USER, :last_name => "Green")
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
    @user.plan.should be_an_instance_of Plan
  end
  
  it "should have a streams array" do
    @user.streams.should be_an_instance_of Array
    if @user.streams.any?
      @user.streams.first.should be_an_instance_of Stream
    end
  end
  
  it "should have a channels array" do
    @user.channels.should be_an_instance_of Array
    if @user.channels.any?
      @user.channels.first.should be_an_instance_of Channel
    end
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