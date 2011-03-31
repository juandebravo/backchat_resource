require 'addressable/uri'

# BackChat.io uses URIs to describe message channels. This class makes it easier
# for users to work with URIs with methods to explode them into hashes and to
# render them from hashes.
module BackchatResource
  class Uri < Addressable::URI
    
  end
end