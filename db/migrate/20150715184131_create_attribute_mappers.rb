class CreateAttributeMappers < ActiveRecord::Migration
  def change
    create_table :attribute_mappers do |t|
      t.integer :mapping_direction, default: 0, null: false
      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
