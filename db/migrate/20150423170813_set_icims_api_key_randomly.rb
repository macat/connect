class SetIcimsApiKeyRandomly < ActiveRecord::Migration
  def up
    Icims::Connection.all.each do |connection|
      if !connection.api_key
        random_hex = SecureRandom.hex(20)
        connection.update(api_key: random_hex)
      end
    end
  end

  def down
    Icims::Connection.all.each do |connection|
      connection.update(api_key: nil)
    end
  end
end
