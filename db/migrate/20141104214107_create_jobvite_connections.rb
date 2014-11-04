class CreateJobviteConnections < ActiveRecord::Migration
  def change
    create_table :jobvite_connections do |t|
      t.string :api_key
      t.string :secret
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
