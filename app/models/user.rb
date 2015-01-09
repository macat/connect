require_relative '../connect/users/user_with_full_name' 
require_relative '../connect/users/access_token_freshner' 

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

  def fresh_access_token(authenticator = authenticator)
    Connect::Users::AccessTokenFreshner.new(self).fresh_access_token
    if access_token_expired?
      refresh_access_token(authenticator)
    end
    access_token
  end

  def access_token_expires_in=(seconds)
    self.access_token_expiry = seconds.to_i.seconds.from_now
  end

  private

  def refresh_access_token(authenticator)
    tokens = authenticator.refresh_access_token(refresh_token)
    self.access_token = tokens.fetch("access_token")
    self.access_token_expires_in = tokens.fetch("expires_in")
    save
  end

  def access_token_expired?
    Time.current > access_token_expiry
  end

  def authenticator
    Authenticator.new(subdomain)
  end
end
