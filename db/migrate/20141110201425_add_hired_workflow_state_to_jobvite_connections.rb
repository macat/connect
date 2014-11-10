class AddHiredWorkflowStateToJobviteConnections < ActiveRecord::Migration
  def change
    add_column :jobvite_connections, :hired_workflow_state, :string, default: "Offer Accepted", null: false
  end
end
