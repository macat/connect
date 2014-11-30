class User < ActiveRecord::Base
  has_one :jobvite_connection, class_name: "Jobvite::Connection"

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def jobvite_connection
    super || Jobvite::Connection.create(user: self)
  end

  def namely_connection
    Namely::Connection.new(
      access_token: fresh_access_token,
      subdomain: subdomain,
    )
  end

  def fresh_access_token(authenticator = authenticator)
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
    tokens = authenticator.refresh_access_token
    self.access_token = tokens.fetch("access_token")
    self.access_token_expires_in = tokens.fetch("expires_in")
    save
  end

  def access_token_expired?
    Time.current > access_token_expiry
  end
end
