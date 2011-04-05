require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Channel" do
  
  before(:each) do
    @channel = Channel.build_from_uri("twitter://backchatio?bql=text%20has%20%22something%22#timeline")
  end
  
  it "has a uri" do
    @channel.uri.should be_instance_of BackchatUri
  end
  
  it "has a source" do
    @channel.source.should be_instance_of Source
  end

  it "has a kind" do
    @channel.kind.should be_instance_of Kind
  end
  
  it "can build an instance from a BackchatUri" do
    result = Channel.build_from_uri(@channel.uri)
    result.should be_instance_of Channel
    result.uri.to_s.should == @channel.uri.to_s
  end
  
  it "can build an instance from an API JSON response hash" do
    from_api = {
    }
    ch = Channel.build_from_uri(from_api)
    ch.should be_instance_of Channel
  end
  
end