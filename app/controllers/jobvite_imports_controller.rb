class JobviteImportsController < ApplicationController
  def create
    jobvite_import = Jobvite::Import.new(
      jobvite_connection,
      namely_connection: current_user.namely_connection,
    )
    jobvite_import.import
    redirect_to dashboard_path, notice: jobvite_import.status
  end

  private

  def jobvite_connection
    current_user.jobvite_connection
  end
end
