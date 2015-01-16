class CreateHipchatConnections < ActiveRecord::Migration
  def change
    create_table :hipchat_connections do |t|
      t.string :api_key
      t.integer :user_id

      t.timestamps
    end
  end
end
