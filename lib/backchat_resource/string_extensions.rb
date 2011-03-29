String.class_eval do

  # @return {String} Convert from any string into a slug-safe (URL safe) key
  def to_slug
    ret = self.downcase.strip
    #blow away apostrophes
    ret.gsub!(/['`]/,"")

    # @ --> at, and & --> and
    ret.gsub!(/\s*@\s*/, " at ")
    ret.gsub!(/\s*&\s*/, " and ")
    
    #replace all non alphanumeric, underscore or periods with underscore
    ret.gsub!(/\s*[^A-Za-z0-9\.\-]\s*/, '-' )

    #convert double underscores to single
    ret.gsub!(/(_|-)+/,"-")

    #strip off leading/trailing underscore
    ret.gsub!(/\A[_\.]+|[_\.]+\z/,"")
    
    ret
  end

end