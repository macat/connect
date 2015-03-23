class AddKeyToIcimsConnection < ActiveRecord::Migration
  def change
    add_column :icims_connections, :key, :string
    remove_column :icims_connections, :password
  end
end
