class HttpClients::Models::TmdbDiscoverMoviesRequest
  attr_accessor :start_date, :end_date, :page

  def initialize(start_date: nil, end_date: nil, page: 1, lang: "en-US", include_adult: false)
    @include_adult = include_adult
    @start_date = start_date
    @end_date = end_date
    @language = lang
    @page = page
  end

  def to_params
    params = {}
    params["primary_release_date.gte"] = @start_date if @start_date
    params["primary_release_date.lte"] = @end_date if @end_date
    params[:page] = @page if @page

    params[:include_adult] = @include_adult
    params[:language] = @language
    params
  end
end
