class JobviteImportsController < ApplicationController
  def create
    jobvite_import = Jobvite::Import.new(current_user)
    @candidates = jobvite_import.import.to_a
  end
end
