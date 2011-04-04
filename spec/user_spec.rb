require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "User" do

  TEST_USER = "brenda"
  TEST_PASS = "gr33n"
  TEST_FULLNAME = "Brenda Green"
  TEST_API_KEY = "BRENDA_API_KEY"
  
  before(:each) do
    @user = User.authenticate(TEST_USER,TEST_PASS)
  end
  
  it "authenticates a valid user and returns a User instance" do                         
    @user.should_not be_nil
    @user.class.should == User
    @user.full_name.should == TEST_FULLNAME
    @user.api_key.should == TEST_API_KEY
  end
  
  # it "generates a random api_key for a logged in user" do
  #   old_api_key = @user.api_key
  #   key = @user.generate_random_api_key!
  #   @user.api_key.should_not == old_api_key
  #   @user.api_key.should be_an_instance_of String
  #   key.should == @user.api_key
  # end
  
  it "sends password reminders for non-logged in users" do
    User.send_password_reminder(TEST_USER)
  end
  
  it "has a full name" do
    @user.full_name.should == TEST_FULLNAME
  end
  
  it "has all it's fields set from the JSON document" do
    @user._id.should_not be_nil
    @user.email.should_not be_nil
    @user.login.should_not be_nil
    @user.first_name.should_not be_nil
    @user.last_name.should_not be_nil
    @user.api_key.should_not be_nil
    @user.plan.should_not be_nil
    @user.streams.should_not be_nil
    @user.channels.should_not be_nil
  end
  
  it "can set properties on a new instance (one not loaded from a API JSON document)" do
    u = User.new
    # This is a non-`attr_accesor` field, only set via the `schema`
    u.postcode = "test"
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
  
  it "should allow the plan to be changed" do
    @user.plan = Plan.find("amazon")
    @user.save
    @user.plan.id.should == "amazon"
  end
  
  it "should find a channel that matches a URI as input" do
    ch = @user.channels.first
    ch.should_not == nil
    channels = @user.find_channels_for_uri(ch.uri)
    channels.length.should be > 0
    channels.first.should == ch
  end
  
  it "should find a channel that matches a URI as input" do
    @user.find_channels_for_uri("twitter://backchatio").should_not == nil
  end
  
  it "should find streams using a channel" do
    # puts @user.streams.inspect
    ch = @user.find_channels_for_uri("smtp://brenda.bieber-fever#smtp")
    ch.should_not be_nil
    streams = @user.find_streams_using_channel(ch.first)
    streams.should_not == []
  end
  
  it "should return empty array when finding streams using a channel for the curerent_user and no such streams exist" do
    pending
    # ch = Channel.new(:uri => "twitter://madeup#timeline")
    # streams = @user.find_streams_using_channel(ch)
    # streams.should == []
  end
  
  it "should save changes to stream objects on user save" do
    pending "Streams are saved to a different URL than user, so on save also post/put /1/streams/"
  end
  
end