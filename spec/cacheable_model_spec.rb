require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cacheable models" do
  
  class ShortCacheableUserScopedModel < BackchatResource::Base
    extend Cacheable
    cache_api_response :duration => :short, :scope => :user
    # 
  end

  class ShortCacheableUnscopedModel < BackchatResource::Base
    extend Cacheable
    cache_api_response :duration => :short, :scope => :everyone
    # 
  end

  it "should have a shared cache instance amongst all instances" do
    pending
  end

end