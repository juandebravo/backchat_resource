# String extensions
String.class_eval do

  def to_slug
    # ret = self.transliterate.downcase.strip
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

  # def transliterate
  #   # Unidecode gem is missing some hyphen transliterations
  #   self.gsub(/[-‐‒–—―⁃−­]/u, '-').to_ascii
  # end

end