require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "fakeweb_routes"

describe "BackchatResource::Models::Plan" do
  
  include BackchatResource::Models
  
  it "should find a list of all plans" do
    all = Plan.all
    all.length.should == 5
  end
  
  it "should find a plan by name" do
    free = Plan.find("free")
    free.name.should == "free"
    free.price.should == 0
  end
  
end