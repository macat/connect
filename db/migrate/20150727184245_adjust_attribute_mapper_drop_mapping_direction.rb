class AdjustAttributeMapperDropMappingDirection < ActiveRecord::Migration
  def up
    remove_column :attribute_mappers, :mapping_direction
  end

  def down
    add_column(
      :attribute_mappers,
      :mapping_direction,
      :integer,
      default: 0,
      null: false
    )
  end
end
