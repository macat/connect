class CreateIcimsConnections < ActiveRecord::Migration
  def change
    create_table :icims_connections do |t|
      t.timestamps null: false

      t.string :username
      t.string :password
      t.belongs_to :user, null: false, index: true
    end
  end
end
