class JobviteImportsController < ApplicationController
  def create
    jobvite_import = Jobvite::Import.new(current_user)
    jobvite_import.import
    redirect_to dashboard_path, notice: jobvite_import.status
  end
end
