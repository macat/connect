class AddAccessTokenExpiry < ActiveRecord::Migration
  def change
    add_column :users, :access_token_expiry, :datetime, default: Time.at(0), null: false
  end
end
