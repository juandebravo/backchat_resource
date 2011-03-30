require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BackchatResource::Base" do
  
  TEST_API_KEY = "My_Test_Api_Key"
  
  before(:all) do
    BackchatResource::Base.api_key = nil
  end
  
  it "should load the site base URI from the config file" do
    BackchatResource::Base.site.to_s.should == "http://localhost:8080/1/"
  end

  it "should have an api_key attr we can set" do
    BackchatResource::Base.api_key = TEST_API_KEY
    BackchatResource::Base.api_key.should == TEST_API_KEY
  end
  
  it "should have an api_key attr we can set through the setup method" do
    BackchatResource.setup(TEST_API_KEY) 
    BackchatResource::Base.api_key.should == TEST_API_KEY
  end
  
  it "should have an api_key attr which is inherited by subclasses" do
    key = "MY_TEST_KEY"
    BackchatResource::Base.api_key = TEST_API_KEY
    BackchatResource::Base.api_key.should == TEST_API_KEY
    BackchatResource::Models::Stream.api_key.should == TEST_API_KEY
  end
  
  it "should set the authorization header for http requests" do
    BackchatResource::Base.api_key = TEST_API_KEY
    BackchatResource::Base.headers.should include({"Authorization" => "Backchat #{TEST_API_KEY}"})
  end
  
  it "should load from a BackChat.io JSON response document's Hash" do
    response = {
      :data => {
        :name => "Name",
        :description => "Description of object"
      },
      :errors => {
        
      }
    }
    result = DummyModel.new(response)
    result.name.should == response[:data][:name]
    result.description.should == response[:data][:description]
    result.errors.should == {}
  end
  
  # Use this model to test error handling
  class DummyModel < BackchatResource::Base
    schema do 
      string 'name','description','validated_field' 
    end
    validates_presence_of :validated_field
  end
  
  it "should load errors from a BackChat.io JSON response document's Hash" do
    response = {
      :data => {},
      :errors => {
        "name" => "has an error"
      }
    }
    result = DummyModel.new(response)
    result.errors[:name].should == ["has an error"]
  end
  
  it "should flag an object as invalid if it has errors loaded from JSON response" do
    response = {
      :data => {},
      :errors => {
        "name" => "has an error"
      }
    }
    result = DummyModel.new(response)
    result.errors[:name].should == ["has an error"]
    result.server_errors[:name].should == ["has an error"]
    result.valid?.should == false
    result.errors[:name].should == ["has an error"]
    result.server_errors[:name].should == ["has an error"]
  end

  it "should be able to fix validation errors on models" do
    response = {
      :data => {
        :validated_field => nil
      },
      :errors => {}
    }
    result = DummyModel.new(response)
    result.valid?.should == false
    result.errors[:validated_field].should == ["can't be blank"]

    result.validated_field = "valid"
    
    result.valid?.should == true
  end
  
  it "should not be possible to fix server-generated errors on models" do
    response = {
      :data => {},
      :errors => {
        "name" => "is invalid"
      }
    }
    result = DummyModel.new(response)
    result.valid?.should == false
    result.errors[:name].should == ["is invalid"]
    result.name = "something else"
    result.valid?.should == false
  end
  
  it "should be able to instantiate an object collection from a BackChat.io JSON collection response document" do
    collection_hash_from_json = {
      "data" => [
        { "name" => "Item 1" },
        { "name" => "Item 2" }
      ],
      "errors" => {}
    }
    
    coll = BackchatResource::Base.instantiate_collection(collection_hash_from_json)
    coll.length.should == 2
    coll[0].name.should == "Item 1"
    coll[1].name.should == "Item 2"
  end

  it "should be able to instantiate an object collection from a JSON collection response document without a data element" do
    collection_array_from_json = [
      { "name" => "Item 1" },
      { "name" => "Item 2" }
    ]
    
    coll = BackchatResource::Base.instantiate_collection(collection_array_from_json)
    coll.length.should == 2
    coll[0].name.should == "Item 1"
    coll[1].name.should == "Item 2"
  end
  
end
