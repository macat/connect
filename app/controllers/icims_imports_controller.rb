class IcimsImportsController < ApplicationController
  def create
    @icims_imports_presenter = ImportsPresenter.new(importer.import)
  end

  private

  def importer
    build_importer(
      connection: current_user.icims_connection,
      client: Icims::Client.new(current_user.icims_connection),
      namely_importer: namely_importer(
        attribute_mapper: Icims::AttributeMapper.new,
      )
    )
  end
end
