require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BackchatResource::Models::Plan" do
  
  it "should find a list of all plans" do
    all = Plan.all
    all.length.should == 5
  end
  
  it "should find a plan by name" do
    free = Plan.find("free")
    free.name.should == "free"
    free.price.should == 0
  end
  
  it "should return the plan name as id" do
    free = Plan.find("free")
    free.id.should == free.name
  end
  
  it "has a uri" do
    free = Plan.find("free")
    free.api_url.should == "http://localhost:8080/1/plans/free.json"
  end
  
end