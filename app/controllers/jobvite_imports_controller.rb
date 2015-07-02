class JobviteImportsController < ApplicationController
  def create
    @jobvite_imports_presenter = ImportsPresenter.new(importer.import)
  rescue Unauthorized
    flash[:error] = t("jobvite_connections.authentication_error")
    redirect_to dashboard_path
  end

  private

  def importer
    build_importer(
      connection: current_user.jobvite_connection,
      client: Jobvite::Client.new(current_user.jobvite_connection),
      namely_importer: namely_importer(
        attribute_mapper: Jobvite::AttributeMapper.new,
      )
    )
  end
end
