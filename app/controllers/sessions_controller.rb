class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :oauth_callback, :destroy]

  def new
    if logged_in?
      redirect_to dashboard_path
    else
      redirect_to namely_authentication_url
    end
  end

  def oauth_callback
    session[:current_user_id] = new_session.user_id

    if logged_in?
      redirect_to(
        dashboard_path,
        notice: t("flashes.sign_in_succeeded", name: current_user.full_name),
      )
    else
      redirect_to root_path, notice: t("flashes.sign_in_failed")
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path, notice: t("flashes.signed_out")
  end

  private

  def new_session
    Session.new(
      authenticator,
      code: params.fetch(:code),
      subdomain: params.fetch(:state),
    )
  end

  def namely_authentication_url
    authenticator.authorization_code_url(
      host: namely_host,
      protocol: namely_protocol,
      redirect_uri: session_oauth_callback_url,
      state: namely_subdomain,
    )
  end

  def authenticator
    Namely::Authenticator.new(
      client_id: Rails.configuration.namely_client_id,
      client_secret: Rails.configuration.namely_client_secret,
    )
  end

  def namely_subdomain
    params.require(:namely_authentication).fetch(:subdomain)
  end

  def namely_host
    Rails.configuration.namely_authentication_domain % {
      subdomain: namely_subdomain,
    }
  end

  def namely_protocol
    Rails.configuration.namely_authentication_protocol
  end
end
