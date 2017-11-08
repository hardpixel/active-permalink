class CreatePermalinks < ActiveRecord::Migration[5.0]
  def change
    create_table :permalinks do |t|
      t.string  :slug
      t.integer :sluggable_id,   null: false
      t.string  :sluggable_type, null: false

      t.timestamps
    end

    add_index :permalinks, [:sluggable_id, :sluggable_type, :slug], unique: true, name: :index_permalinks_on_sluggable_attribute
  end
end
