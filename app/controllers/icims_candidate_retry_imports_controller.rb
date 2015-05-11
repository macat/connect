class IcimsCandidateRetryImportsController < ApplicationController
  def show
    service = Icims::CandidateImporter.new(connection,
                                           IcimsCandidateImportMailer,
                                           params)
    service.import
    @candidate = service.candidate
    @import = service.imported_result
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
