module CustomCache
  class MovieCache < ActiveSupport::Cache::Store
    prepend ActiveSupport::Cache::Strategy::LocalCache

    def initialize(connection)
      @connection = connection
      @table_name = "movie_cache_entries"
      super({})
    end

    def self.supports_cache_versioning?
      true
    end

    def read_entry(key, options)
      entry = MovieCacheEntry.valid_entries.find_by(key: normalize_key(key, options))
      entry&.value ? deserialize_entry(entry.value) : nil
    end

    def write_entry(key, entry, options)
      MovieCacheEntry.upsert(
        {
          key: normalize_key(key),
          value: serialize_entry(entry),
          byte_size: entry.bytesize,
          expires_at: Time.current + options[:expires_in]
        },
        unique_by: [ :key ])
      true
    end

    def delete_entry(key, options)
      MovieCacheEntry.where(key: normalize_key(key, options)).delete_all
      true
    end

    def cleanup(options)
      MovieCacheEntry.expired_entries.delete_all
    end
  end
end
