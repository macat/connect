class HipchatImportsController < ApplicationController
  def create
    importer = Hipchat::Importer.new(
      token: current_user.hipchat_connection.api_key,
      namely_connection: current_user.namely_connection)

    @imported_profiles = importer.import.to_a
  end
end
