class Session
  delegate :id, to: :user, prefix: true

  def initialize(authenticator, code:, subdomain:, user_model: User)
    @authenticator = authenticator
    @code = code
    @subdomain = subdomain
    @user_model = user_model
  end

  def user
    @user ||= user_model.find_or_initialize_by(
      namely_user_id: namely_user.id,
      subdomain: subdomain,
    ).tap do |user|
      user.update!(
        access_token: access_token,
        access_token_expires_in: access_token_expiry,
        refresh_token: refresh_token,
        first_name: namely_user.first_name,
        last_name: namely_user.last_name,
      )
    end
  end

  private

  attr_reader :authenticator, :code, :subdomain, :user_model

  def namely_user
    @namely_user ||= authenticator.current_user(
      access_token: access_token,
      host: namely_host,
      protocol: Rails.configuration.namely_authentication_protocol,
    )
  end

  def access_token
    tokens.fetch("access_token")
  end

  def access_token_expiry
    tokens.fetch("expires_in")
  end

  def refresh_token
    tokens.fetch("refresh_token")
  end

  def tokens
    @tokens ||= authenticator.retrieve_tokens(
      code: code,
      host: namely_host,
      protocol: Rails.configuration.namely_authentication_protocol,
      redirect_uri: Rails.configuration.namely_authentication_redirect_uri,
    )
  end

  def namely_host
    Rails.configuration.namely_authentication_domain % {
      subdomain: subdomain,
    }
  end
end
