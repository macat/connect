class AddFoundNamelyFieldToJobviteConnections < ActiveRecord::Migration
  def change
    add_column :jobvite_connections, :found_namely_field, :boolean, null: false, default: false
  end
end
