class User < ActiveRecord::Base
  has_one :jobvite_connection, class_name: "Jobvite::Connection"

  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def jobvite_connection
    super || Jobvite::Connection.create(user: self)
  end

  def namely_connection
    Namely::Connection.new(access_token: access_token, subdomain: subdomain)
  end

  def fresh_access_token(authenticator = authenticator)
    if access_token_expired?
      refresh_access_token(authenticator)
    end
    access_token
  end

  private

  def refresh_access_token(authenticator = authenticator)
    tokens = authenticator.refresh_access_token(
      redirect_uri: Rails.configuration.namely_authentication_redirect_uri,
      refresh_token: refresh_token,
      subdomain: subdomain,
    )
    self.access_token = tokens.fetch("access_token")
    save
  end

  def access_token_expired?
    Time.current > access_token_expiry
  end

  def authenticator
    Namely::Authenticator.new(
      client_id: Rails.configuration.namely_client_id,
      client_secret: Rails.configuration.namely_client_secret,
    )
  end
end
