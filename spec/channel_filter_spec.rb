require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ChannelFilter" do

  it "can be enabled and disabled" do
    cf = ChannelFilter.new
    cf.enabled = true
    cf.enabled.should == true
    cf.enabled = false
    cf.enabled.should == false
  end
  
  it "has a settable BQL string" do
    cf = ChannelFilter.new(:uri => "twitter://backchatio#timeline")
    cf.uri.bql = 'text has "something in it"'
    cf.uri.bql.should == 'text has "something in it"'
  end

  it "should return nil if there is no BQL set" do
    cf = ChannelFilter.new(:uri => "twitter://backchatio#timeline")
    cf.uri.bql.should == nil
  end
    
  it "can be built from a URI" do
    cf = ChannelFilter.build("twitter://backchatio#timeline")
    cf.uri.to_s.should == "twitter://backchatio/#timeline"
  end
  
  it "should be disabled by default" do
    cf = ChannelFilter.build("twitter://backchatio#timeline")
    cf.enabled.should == false
    cf.enabled?.should == false
  end
  
  it "has a settable BQL attr that sets the bql querystring in the uri attribute" do
    cf = ChannelFilter.build("twitter://backchatio#timeline")
    cf.uri.bql = 'text has "something"'
    cf.uri.to_s.should == "twitter://backchatio/?bql=text%20has%20%22something%22#timeline"
  end
  
  it "shouldn't wipe other querystirng params when setting another" do
    cf = ChannelFilter.build("twitter://backchatio?other=true#timeline")
    cf.uri.bql = 'text has "something"'
    
    keys = cf.uri.querystring_params.keys
    keys.should include "bql"
    keys.should include "other"
  end
  
end