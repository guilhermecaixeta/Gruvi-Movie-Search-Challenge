class HttpClients::Models::TmdbDiscoverMoviesRequest
  attr_accessor :start_date, :end_date, :page

  def initialize(start_date: nil, end_date: nil, page: 1, lang: "en-US", sort_by: "primary_release_date.asc")
    @include_adult = false
    @start_date = start_date
    @end_date = end_date
    @sort_by = sort_by
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
    params[:sort_by] = @sort_by
    params
  end
end
