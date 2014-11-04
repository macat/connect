class User < ActiveRecord::Base
  has_one :jobvite_connection

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def jobvite_connection
    super || JobviteConnection.create(user: self)
  end
end
