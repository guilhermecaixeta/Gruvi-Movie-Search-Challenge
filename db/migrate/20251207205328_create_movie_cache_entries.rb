class CreateMovieCacheEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :movie_cache_entries do |t|
      t.string :key, null: false
      t.binary :value, null: false
      t.integer :byte_size, null: false
      t.datetime :expires_at, null: false
      t.index [ :key ], unique: true
      t.index [ :expires_at ], where: 'expires_at IS NOT NULL'
      t.timestamps
    end
  end
end
