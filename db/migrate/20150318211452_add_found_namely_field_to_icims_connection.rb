class AddFoundNamelyFieldToIcimsConnection < ActiveRecord::Migration
  def change
    add_column :icims_connections, :found_namely_field, :boolean, null: false, default: false
  end
end
