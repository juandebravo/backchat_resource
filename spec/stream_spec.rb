require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BackchatResource::Models::Stream" do
  
  class Stream < BackchatResource::Models::Stream; end
  
  it "should generate a collection URL that is supported by BackChat.io's API" do
    s = Stream.new
    s.send(:collection_path).should == "/1/streams/index.json"
  end

  it "should generate an individual record URL, based off the slug, that is supported by BackChat.io's API" do
    s = Stream.new(:slug => "mojolly-crew")
    s.send(:element_path).should == "/1/streams/mojolly-crew.json"
  end
  
end