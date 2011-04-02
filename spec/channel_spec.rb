require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Channel" do
  
  before(:each) do
    @channel = Channel.build_from_uri("twitter://backchatio?bql=text%20has%20%22something%22#timeline")
  end
  
  it "has a source" do
    pending
  end

  it "has a kind" do
    pending
  end
  
  it "can build an instance from a URI string" do
    pending "build_from_uri"
  end

  it "can build an instance from a URI hash (as returned from the API JSON doc)" do
    pending "build_from_uri"
  end
  
  it "can build an instance from a BackchatUri" do
    pending "build_from_uri"
  end
  
  it "can build an instance from an API JSON response hash" do
    pending
  end
  
end