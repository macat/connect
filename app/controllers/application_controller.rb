class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  private

  def require_login
    unless logged_in?
      redirect_to root_path, notice: t("flashes.sign_in_required")
      false
    end
  end

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end
  helper_method :current_user

  def namely_importer(attribute_mapper:)
    NamelyImporter.new(
      attribute_mapper: attribute_mapper,
      namely_connection: current_user.namely_connection,
    )
  end

  def build_importer(client:, connection:, namely_importer:)
    Importer.new(
      current_user,
      client: client,
      connection: connection,
      namely_importer: namely_importer,
    )
  end
end
