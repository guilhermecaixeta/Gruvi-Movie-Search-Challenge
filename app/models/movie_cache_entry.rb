class MovieCacheEntry < ApplicationRecord
  validates :key, :value, presence: true

  scope :valid_entries, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :expired_entries, -> { where("expires_at IS NOT NULL AND expires_at <= ?", Time.current) }
end
