class IcimsImportsController < ApplicationController
  def create
    @icims_candidates = imported_candidates
  end

  private

  def imported_candidates
    importer.import.to_a.map { |t| t[:candidate] }
  end

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
