require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'backchat_resource/backchat_uri'

describe "BackchatResource::BackchatUri" do

  
  it "can expand a uri" do
    pending
  end
  
  
  # # The blank shape to be merged with expected results
  # parts_shape = {
  #   :scheme=>nil,
  #   :user=>nil,
  #   :password=>nil,
  #   :source=>nil,
  #   :port=>nil,
  #   :resource=>nil,
  #   :resources=>nil,
  #   :querystring=>nil,
  #   :query=>nil,
  #   :kind=>nil,
  #   :resource_kind=>nil
  # }
  # 
  # context "convert from a uri" do
  # 
  #   it "should convert from a Uri without a kind" do
  #     uri = "twitter://casualjim"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     # puts bcuri.inspect
  #     # puts bcuri.parts.inspect
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim"
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a channel kind" do
  #     uri = "twitter://casualjim#trends"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :kind => "trends"
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a channel kind" do
  #     uri = "twitter://casualjim#trends"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :kind => "trends"
  #     })
  #   end
  # 
  #   it "should convert from a channel with escaped hash" do
  #     uri = "twitter://casualjim%23timeline"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :kind => "timeline"
  #     })      
  #   end
  # 
  #   it "convert from a Uri with a channel kind and channel resource" do
  #     uri = "twitter://casualjim#timeline/yesterday"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :kind => "timeline",
  #      :resource_kind => "yesterday"
  #     })
  #   end
  # 
  #   it "should parse an xmpp uri" do
  #     uri = "xmpp://adam@mojolly.com:pass123@xmpp.mojolly.com:3000/mymacbook#muc/myroom"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "xmpp",
  #      :user => "adam@mojolly.com",
  #      :password => "pass123",
  #      :source => "xmpp.mojolly.com",
  #      :port => 3000,
  #      :resource => "mymacbook",
  #      :resources => ["mymacbook"],
  #      :kind => "muc",
  #      :resource_kind => "myroom"
  #     })
  #   end
  # 
  #   it "should parse an encoded xmpp uri" do
  #     uri = "xmpp%3A%2F%2Fadam%40mojolly.com%3Apass123%40xmpp.mojolly.com%3A3000%2Fmymacbook%23muc%2Fmyroom"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "xmpp",
  #      :user => "adam@mojolly.com",
  #      :password => "pass123",
  #      :source => "xmpp.mojolly.com",
  #      :port => 3000,
  #      :resource => "mymacbook",
  #      :resources => ["mymacbook"],
  #      :kind => "muc",
  #      :resource_kind => "myroom"
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a querystring" do
  #     uri = "twitter://casualjim?bql=text%20has%20something"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :querystring => "bql=text%20has%20something",
  #      :query => {
  #        "bql" => "text has something"
  #      }
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a querystring with multi params" do
  #     uri = "twitter://casualjim?bql=text%20has%20something&something=else"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :querystring => "bql=text%20has%20something&something=else",
  #      :query => {
  #        "bql" => "text has something",
  #        "something" => "else"
  #      }
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a kind and querystring with multi params" do
  #     uri = "twitter://casualjim?bql=text%20has%20something&something=else#timeline"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "twitter",
  #      :source => "casualjim",
  #      :querystring => "bql=text%20has%20something&something=else",
  #      :query => {
  #        "bql" => "text has something",
  #        "something" => "else"
  #      },
  #      :kind => "timeline"
  #     })
  #   end
  # 
  #   it "should convert from a Uri with a fragment and fragment resource" do
  #     uri = "xmpp://ivan@mojolly.com:password123@xmpp.mojolly.com/adium#muc/room"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #      :scheme => "xmpp",       
  #      :user => "ivan@mojolly.com",
  #      :password => "password123",
  #      :source => "xmpp.mojolly.com",
  #      :resource => "adium",
  #      :resources => ["adium"],
  #      :kind => "muc",
  #      :resource_kind => "room"
  #     })
  #   end
  # 
  #   it "should convert from a Uri with alternative credential passing" do
  #     uri = "twitter://backchatio?user=ivan@mojolly.com&pass=password123"
  #     bcuri = BackchatResource::BackchatUri.parse(uri)
  #     bcuri.parts.should == parts_shape.merge({
  #       :scheme => "twitter",       
  #       :source => "backchatio",
  #       :querystring => "user=ivan@mojolly.com&pass=password123",
  #       :query => {
  #         "user" => "ivan@mojolly.com",
  #         "pass" => "password123"
  #       },
  #       :user => "ivan@mojolly.com",
  #       :password => "password123"
  #     })
  #   end
  
  # endnd

end