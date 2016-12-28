class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.string :slug

      t.timestamps null: false
    end

    add_index :groups, :slug, unique: true
  end
end
