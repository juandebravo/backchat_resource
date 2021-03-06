# Extend the string to have a to_slug method which creates a URL friendly version of a string
String.class_eval do
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