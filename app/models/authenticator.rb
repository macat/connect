class Authenticator
  attr_reader :namely_authenticator, :subdomain
  def initialize(subdomain)
    @namely_authenticator = Namely::Authenticator.new(
      client_id: Rails.configuration.namely_client_id,
      client_secret: Rails.configuration.namely_client_secret,
    )
    @subdomain = subdomain
  end

  def authorization_code_url(callback_url)
    namely_authenticator.authorization_code_url(
      state: subdomain,
      redirect_uri: callback_url,
      host: namely_authentication_host,
      protocol: Rails.configuration.namely_authentication_protocol,
    )
  end

  def retrieve_tokens(code)
    namely_authenticator.retrieve_tokens(
      code: code,
      redirect_uri: Rails.configuration.namely_api_redirect_uri,
      host: namely_host,
      protocol: namely_protocol,
    )
  end

  def refresh_access_token(refresh_token)
    namely_authenticator.refresh_access_token(
      refresh_token: refresh_token,
      redirect_uri: Rails.configuration.namely_api_redirect_uri,
      host: namely_host,
      protocol: namely_protocol,
    )
  end

  def current_user(access_token)
    namely_authenticator.current_user(
      access_token: access_token,
      subdomain: subdomain,
      host: namely_host,
      protocol: namely_protocol,
    )
  end

  def namely_host
    Rails.configuration.namely_api_domain % {
      subdomain: subdomain,
    }
  end

  def namely_authentication_host
    Rails.configuration.namely_authentication_domain % {
      subdomain: subdomain,
    }
  end

  def namely_protocol
    Rails.configuration.namely_api_protocol
  end
end
