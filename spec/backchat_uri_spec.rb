require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'backchat_resource/backchat_uri'

describe "BackchatResource::BackchatUri" do

  it "should parse a uri" do
    uri = "twitter://backchatio#timeline"
    pending
  end
  
  it "should parse a uri without a kind" do
    uri = "twitter://backchatio"
    pending
  end
  
  it "should parse an escaped URI" do
    uri = "twitter://backchatio%23timeline"
    pending
  end
  
  it "should parse a URI with a querystring param but no kind" do
    uri = "twitter://backchatio?bql=text%20has%20something"
    pending
  end

  it "should parse a URI with a querystring param and a kind" do
    uri = "twitter://backchatio?bql=text%20has%20something#timeline"
    pending
  end
    
  it "should parse a Uri with a querystring with multi params" do
    uri = "twitter://backchatio?bql=text%20has%20something&something=else#timeline"
    pending
  end  
  
  it "should parse a URI with a kind and kind_resource" do
    uri = "tel://080012345678#sms/hashblue"
    pending
  end

  it "should parse a Uri with credential" do
    uri = "rss://basicauthuser:mypass123@server.com/secure/feed.xml"
    pending
  end
  
  it "parsed URIs have a source model instance" do
    pending
  end
  
  it "parsed URIs have a kind model instance" do
    pending
  end
  
  it "has a kind_resource attribute accessor" do
    pending
  end
  
  it "has a params hash containg querystring params" do
    pending
  end
  
  it "can set a querystring param and have it rendered as a string" do
    pending
  end

  it "can set a querystring param, and not clobber any other existing params, and have it rendered as a string" do
    pending
  end

end