class CreateGreenhouseConnections < ActiveRecord::Migration
  def change
    create_table :greenhouse_connections do |t|
      t.timestamps null: false

      t.string :token
      t.string :api_key
      t.boolean :found_namely_field, null: false, default: false
      t.belongs_to :user, null: false, index: true
    end
  end
end
