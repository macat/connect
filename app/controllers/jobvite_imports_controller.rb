class JobviteImportsController < ApplicationController
  def create
    jobvite_import = Jobvite::Import.new(current_user)
    status = jobvite_import.import
    redirect_to dashboard_path, notice: status
  end
end
