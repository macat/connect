class JobviteImportsController < ApplicationController
  def create
    @jobvite_imports_presenter = Jobvite::ImportsPresenter.
      new(importer.import)
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
