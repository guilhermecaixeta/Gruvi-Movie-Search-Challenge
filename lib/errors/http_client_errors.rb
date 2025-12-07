module Errors::HttpClientErrors
  class BaseHttpClientError < StandardError
    attr_accessor :status_code

    def initialize(message, status_code)
      super message
      @status_code = status_code
    end
  end

  class UnauthorizedError < BaseHttpClientError
    def initialize(message)
      super(message, :unauthorized)
    end
  end

  class NotFoundError < BaseHttpClientError
    def initialize(message)
      super(message, :not_found)
    end
  end

  class ServerError < BaseHttpClientError
    def initialize(message)
      super(message, :internal_server_error)
    end
  end

  class ClientError < BaseHttpClientError
    def initialize(message)
      super(message, :internal_server_error)
    end
  end
end
