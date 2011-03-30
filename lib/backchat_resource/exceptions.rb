module BackchatResource
  class Exception < StandardError

    def self.find_exception(e)
      new_exception = if e.respond_to?(:data)
        exception_data = JSON.parse(e)
        code = exception_data['errors']['code']
        exception_klass = backchat_exceptions[code.to_i] if code
        exception_klass.nil? ? e : exception_klass.new
      else
        e
      end
    end

    # Hash mapping error codes to exception classes.
    def self.backchat_exceptions
      {
        123 => BackchatResource::SampleException,
      }
    end

  end
end

class BackchatResource::SampleException < BackchatResource::Exception
  def message
    "This is a sample exception"
  end
end