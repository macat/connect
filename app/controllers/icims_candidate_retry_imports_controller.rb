class IcimsCandidateRetryImportsController < ApplicationController
  def show
    @candidate = Icims::Client.new(connection: connection).candidate(params[:id])
    @import = namely_importer.single_import(@candidate)
  end

  private

  def namely_importer
    NamelyImporter.new(
      namely_connection: current_user.namely_connection,
      attribute_mapper: Icims::AttributeMapper.new,
    )
  end

  def connection
    current_user.icims_connection
  end
end
