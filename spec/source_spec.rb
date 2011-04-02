require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Source" do

  TEST_URI = "twitter://casualjim?bql=something#timeline"
  
  it "can find a Source to match a URI" do
    src = Source.find_for_uri(TEST_URI)
    src.id.should == "twitter"
  end
  
  it "has an array of kinds" do
    src = Source.find_for_uri(TEST_URI)
    src.kinds.should be_instance_of Array
    src.kinds.first.should be_instance_of Kind
  end
  
  it "should have many kinds if specified in the API JSON document" do
    src = Source.find_for_uri("email://")
    src.kinds.should be_instance_of Array
    src.kinds.first.should be_instance_of Kind    
    src.kinds.length.should == 2
  end
  
  it "can find a Source Kind to match a URI" do
    kind = Kind.find_for_uri("twitter://casualjim?bql=something#timeline")
    kind.should be_instance_of Kind
    kind.id.should == "timeline"
    kind.display_name.should == "Twitter Timeline"
  end
  
  it "should serialize a kind to JSON" do
    kind = Kind.find_for_uri("twitter://casualjim?bql=something#timeline")
    kind.to_json.should == "{\"_id\":\"TIMELINE\",\"auth_type\":\"NoAuth\",\"description\":\"Collect a timeline of all public tweets from any Twitter user.\",\"direction\":\"IN\",\"display_name\":\"Twitter Timeline\",\"protocol\":\"HTTPS\",\"short_display_name\":\"Twitter (Timeline)\"}"
  end
  
  # it "should serialize a source to JSON" do 
  #   src = Source.find_for_uri(TEST_URI)
  #   src.to_json.should == ""
  # end
  
end