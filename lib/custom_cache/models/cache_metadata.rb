class CustomCache::Models::CacheMetadata
  include ActiveModel::Validations

  attr_accessor :start_date, :end_date, :page, :ttl

  def initialize(params)
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @page = params[:page] if params.key? :page

    @page ||= 1
    @ttl = 4.hours
  end

  validates :start_date, :end_date, presence: true
  validates :start_date, comparison: { less_than_or_equal_to: :end_date }

  def cache_key
    @cache_key = [ "movies",
                    @start_date.iso8601,
                    @end_date.iso8601,
                    @page ].join(":")
    @cache_key
  end
end
