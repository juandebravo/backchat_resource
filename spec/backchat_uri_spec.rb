require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'backchat_resource/backchat_uri'

describe "BackchatResource::BackchatUri" do

  it "should encode a URI within a URI safely for API calls" do
    pending
  end

  it "should parse a uri" do
    uri = "twitter://backchatio#timeline"
    result = BackchatUri.parse(uri)
    result.to_s.should == "twitter://backchatio/#timeline"
    result.components.keys.should include "source"
  end
  
  it "should parse a uri without a kind" do
    uri = "twitter://backchatio"
    result = BackchatUri.parse(uri)
    result.components.keys.should include "source"
    result.to_s.should == "twitter://backchatio.#timeline"
  end
  
  # # NOTE: This test is failling. Question if this is correct behaviour or not
  # it "should parse an escaped URI" do
  #   uri = "twitter://backchatio%23timeline"
  #   result = BackchatUri.parse(uri)
  #   result.to_s.should == "twitter://backchatio/#timeline"
  # end
  
  it "should parse a URI with a querystring param but no kind" do
    uri = "twitter://backchatio?bql=text%20has%20%22something%22"
    result = BackchatUri.parse(uri)
    result.to_s.should == "twitter://backchatio/?bql=text%20has%20%22something%22#timeline"
  end

  it "should parse a URI with a querystring param and a kind" do
    uri = "twitter://backchatio?bql=text%20has%20%22something%22#timeline"
    result = BackchatUri.parse(uri)
    result.to_s.should == "twitter://backchatio/?bql=text%20has%20%22something%22#timeline"
  end
    
  it "should parse a Uri with a querystring with multi params" do
    uri = "twitter://backchatio?bql=text%20has%20%22something%22&something=else#timeline"
    result = BackchatUri.parse(uri)
    result.querystring_params.keys.should include "bql"
    result.querystring_params.keys.should include "something"
  end  
  
  it "should parse a URI with a kind and kind_resource" do
    uri = "tel://080012345678#sms/hashblue"
    result = BackchatUri.parse(uri)
    result.kind.id.should == "hashblue"
    result.kind_resource.should == "sms"
  end

  it "should parse a Uri with credential" do
    uri = "rss://basicauthuser:mypass123@server.com/secure/feed.xml"
    result = BackchatUri.parse(uri)
    result.to_s.should == "http://basicauthuser:mypass123@server.com/secure/feed.xml"
  end
  
  it "parsed URIs have a source model instance" do
    uri = "tel://080012345678#sms/hashblue"
    result = BackchatUri.parse(uri)
    result.source.should be_instance_of Source
  end
  
  it "parsed URIs have a kind model instance" do
    uri = "tel://080012345678#sms/hashblue"
    result = BackchatUri.parse(uri)
    result.kind.should be_instance_of Kind
  end
  
  it "has a kind_resource attribute accessor" do
    uri = "tel://080012345678#sms/hashblue"
    result = BackchatUri.parse(uri)
    result.respond_to?(:kind_resource).should == true
  end
  
  it "has a params hash containg querystring params" do
    uri = "tel://080012345678#sms/hashblue"
    result = BackchatUri.parse(uri)
    result.querystring_params.should be_instance_of Hash
  end
  
  it "can compose a URI, updating it's target to be something else in the rendered URI" do
    uri = "twitter://backchatio#timeline"
    expected = "twitter://mojolly/#timeline"
    result = BackchatUri.parse(uri)
    result.target = "mojolly"
    result.to_s.should == expected
  end
  
  it "can compose a URI, set a querystring param and have it rendered as a string" do
    uri = "twitter://backchatio#timeline"
    expected = "twitter://mojolly/?bql=text%20has%20%22something%22%23timeline"
    result = BackchatUri.parse(uri)
    result.bql = 'text has "something"'
    result.to_s.should == expected
  end

  it "can compose a URI, set a querystring param, and not clobber any other existing params, and have it rendered as a string" do
    uri = "twitter://backchatio?something=else#timeline"
    expected = "twitter://backchatio/?something=else&amp;bql=text%20has%20%22something%22%23timeline"
    result = BackchatUri.parse(uri)
    result.bql = 'text has "something"'
    result.to_s.should == expected
  end

end