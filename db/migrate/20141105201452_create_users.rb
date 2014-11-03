class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :namely_user_id, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.string :subdomain, null: false
      t.string :first_name
      t.string :last_name
    end
  end
end
