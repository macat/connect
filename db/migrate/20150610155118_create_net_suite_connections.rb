class CreateNetSuiteConnections < ActiveRecord::Migration
  def change
    create_table :net_suite_connections do |t|
      t.belongs_to :user, index: true
      t.string :instance_id
      t.string :authorization

      t.timestamps
    end
  end
end
