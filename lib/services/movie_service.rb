class Services::MovieService
  ITEMS_PER_PAGE = 20

  def initialize
    @http_client = HttpClients::TmdbClient.new
  end
  def fetch(params)
    cache_metadata = CustomCache::Models::CacheMetadata.new params

    if cache_metadata.invalid?
      raise Errors::DomainErrors::InvalidDataError, cache_metadata.errors
    end

     Rails.cache.fetch(cache_metadata.cache_key, expires_in: cache_metadata.ttl) do
      movies = @http_client.find_movies_in_interval(cache_metadata.start_date,
                                                    cache_metadata.end_date,
                                                    cache_metadata.page)
      map_response movies
    end

  rescue StandardError => e
    Rails.logger.error { e.message }
    raise Errors::DomainErrors::InternalError "Check logs for more information."
  end

  def map_response(response)
    # TMDB does not allow page greater than 500
    total_pages = response["total_pages"] > 500 ? 500 : response["total_pages"]
    movies = response["results"].map do |movie|
        {
          id: movie["id"],
          title: movie["title"],
          description: movie["overview"],
          release_date: movie["release_date"]
        }
      end

    {
      page: response["page"],
      total_pages: total_pages,
      items_per_page: ITEMS_PER_PAGE,
      data: movies
    }
  end
end
