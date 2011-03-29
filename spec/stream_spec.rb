require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BackchatResource::Models::Stream" do
  
  it "generates a collection URL that is supported by BackChat.io's API" do
    s = BackchatResource::Models::Stream.new
    s.send(:collection_path).should == "/1/streams/index.json"
  end

  it "generates an individual record URL, based off the slug, that is supported by BackChat.io's API" do
    s = BackchatResource::Models::Stream.new(:slug => "mojolly-crew")
    s.send(:element_path).should == "/1/streams/mojolly-crew.json"
  end

  it "builds a new instance from params" do
    s = BackchatResource::Models::Stream.new(:name => "Mojolly crew", :description => "Mojolly team members")
    s.name.should == "Mojolly crew"
    s.description.should == "Mojolly team members"
  end
  
  it "generates a Slug for a stream from it's name by single assignment" do
    s = BackchatResource::Models::Stream.new
    s.name = "Mojolly crew"
    s.slug.should == "mojolly-crew"
  end
  
  it "generates a Slug for a stream from it's name from mass assignment" do
    s = BackchatResource::Models::Stream.new(:name => "Mojolly crew")
    s.slug.should == "mojolly-crew"
  end
  
  it "returns the slug as it's ID" do
    s = BackchatResource::Models::Stream.new
    s.name = "Mojolly crew"
    s.id.should == s.slug
  end
  
end