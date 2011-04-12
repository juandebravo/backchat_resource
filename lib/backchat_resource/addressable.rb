require 'addressable/uri'

module Addressable
  class URI
    ##
    # Ensures that the URI is valid.
    def validate
      return if !!@validation_deferred
      # if self.scheme != nil &&
      #     (self.host == nil || self.host == "") &&
      #     (self.path == nil || self.path == "")
      #   raise InvalidURIError,
      #     "Absolute URI missing hierarchical segment: '#{self.to_s}'"
      # end
      if self.host == nil
        if self.port != nil ||
            self.user != nil ||
            self.password != nil
          raise InvalidURIError, "Hostname not supplied: '#{self.to_s}'"
        end
      end
      if self.path != nil && self.path != "" && self.path[0..0] != "/" &&
          self.authority != nil
        raise InvalidURIError,
          "Cannot have a relative path with an authority set: '#{self.to_s}'"
      end
      return nil
    end
  end
end