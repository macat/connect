class AddCustomerIdToIcimsConnection < ActiveRecord::Migration
  def change
    add_column :icims_connections, :customer_id, :integer
  end
end
