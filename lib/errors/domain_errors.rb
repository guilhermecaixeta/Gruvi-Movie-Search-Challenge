module Errors::DomainErrors
  class InvalidDataError < StandardError
    def initialize(errors)
      super "The following properties are invalid: '#{errors.full_messages}'"
    end
  end

  class InternalError < StandardError
    def initialize(error_message)
      super "Unexpected error happens: '#{error_message}'"
    end
  end
end
