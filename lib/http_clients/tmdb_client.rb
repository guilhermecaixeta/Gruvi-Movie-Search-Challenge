class HttpClients::TmdbClient
  BASE_URL = "https://api.themoviedb.org".freeze

  def find_movies_in_interval(start_date, end_date, page)
    request_params = HttpClients::Models::TmdbDiscoverMoviesRequest.new(
      start_date: start_date,
      end_date: end_date,
      page: page).to_params

    request(:get, "/3/discover/movie", params: request_params)
  end

  private

  def request(method, path, body: nil, params: {})
    response = connection.public_send(method, path) do |req|
      req.params = params if params.any?
      req.body = body.to_json if body
    end

    handle_response(response)
  rescue Faraday::Error => e
    raise ServerError, "Request failed: #{e.message}"
  end

  def handle_response(response)
    case response.status
    when 200..299
      response.body
    when 401
      raise Errors::HttpClientErrors::UnauthorizedError, "Authentication failed"
    when 404
      raise Errors::HttpClientErrors::NotFoundError, "Resource not found"
    when 500..599
      raise Errors::HttpClientErrors::ServerError, "Server error: #{response.status}"
    else
      raise Errors::HttpClientErrors::ClientError, "Unexpected response: #{response.status}"
    end
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |conn|
      conn.headers["Authorization"] = "Bearer #{api_key}"
      conn.headers["Content-Type"] = "application/json"
      conn.headers["Accept"] = "application/json"
      conn.request :json
      # conn.request :log, Rails.logger, bodies: true, headers: true
      conn.response :json
      conn.response :logger, Rails.logger, bodies: true, headers: true
      conn.adapter Faraday.default_adapter
      conn.options.timeout = @timeout
    end
  end

  def api_key
    @api_key ||= Rails.application.credentials.dig(:tmdb, :api_key)
  end
end
