class AddSubsidiaryIdToNetSuiteConnections < ActiveRecord::Migration
  def change
    add_column :net_suite_connections, :subsidiary_id, :string
  end
end
