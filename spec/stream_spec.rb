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
  
  it "has channel_filters, which are empty by default" do
    s = BackchatResource::Models::Stream.new
    s.channel_filters.should == []
  end
  
  it "has channel_filters, which are populated by ChannelFilter models when creating a stream from a JSON response document" do
    hash_from_json_response_doc = {
      :data => {
        :name => "Example doc with channel filters",
        :channel_filters => [
          {
            :uri => "smtp://adam.mojolly-crew",
            :canonical_uri => "smtp://adam.mojolly-crew",
            :enabled => true
          },
          {
            :uri => "twitter://casualjim?bql=text has \"mojolly\" or text has \"backchat \"#timeline\"",
            :canonical_uri => "twitter://casualjim#timeline",
            :enabled => true
          }
        ]
      },
      :errors => {}
    }
    s = BackchatResource::Models::Stream.new(hash_from_json_response_doc)
    s.channel_filters.length.should == 2
    s.channel_filters[0].class.should == BackchatResource::Models::ChannelFilter
    s.channel_filters[0].canonical_uri.should == "smtp://adam.mojolly-crew"
  end
  
end