require_relative '../connect/users/user_with_full_name' 
require_relative '../connect/users/access_token_freshener' 
require_relative '../connect/users/token_expiry' 

class User < ActiveRecord::Base
  has_one :jobvite_connection, class_name: "Jobvite::Connection"
  has_one :icims_connection, class_name: "Icims::Connection"

  def full_name
    Connect::Users::UserWithFullName.new(self).full_name
  end

  def jobvite_connection
    super || Jobvite::Connection.create(user: self)
  end

  def icims_connection
    super || Icims::Connection.create(user: self)
  end

  def namely_connection
    Namely::Connection.new(
      access_token: fresh_access_token,
      subdomain: subdomain,
    )
  end

  def fresh_access_token
    Connect::Users::AccessTokenFreshener.fresh_access_token(self)
  end

  def save_token_info(access_token, access_token_expires_in)
    self.access_token = access_token
    self.access_token_expiry = Connect::Users::TokenExpiry.for(access_token_expires_in)
    save
  end
end
