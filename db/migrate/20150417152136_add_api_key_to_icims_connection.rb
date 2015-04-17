class AddApiKeyToIcimsConnection < ActiveRecord::Migration
  def change
    add_column :icims_connections, :api_key, :string
  end
end
