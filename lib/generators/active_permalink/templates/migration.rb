class CreatePermalinks < ActiveRecord::Migration[5.0]
  def change
    create_table :permalinks do |t|
      t.string  :scope,          default: 'global'
      t.boolean :active,         default: true
      t.string  :slug,           null: false
      t.integer :sluggable_id,   null: false
      t.string  :sluggable_type, null: false

      t.timestamps
    end

    add_index :permalinks, [:scope, :slug], unique: true
    add_index :permalinks, [:sluggable_id, :sluggable_type], name: :index_permalinks_on_sluggable_attribute
  end
end
