class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :title
      t.string :url
      t.string :slug
      t.integer :series_id, index: true
      t.integer :group_id, index: true
      t.datetime :released_at, null: false

      t.timestamps null: false
    end

    add_index :releases, :slug, unique: true
  end
end
