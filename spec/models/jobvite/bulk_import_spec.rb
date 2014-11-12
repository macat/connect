require "rails_helper"

describe Jobvite::BulkImport do
  describe "#import" do
    it "imports Jobvite candidates for each of the users" do
      first_user = double("user", id: 1)
      second_user = double("user", id: 2)
      users = [first_user, second_user]
      import_instance = double("import_instance", import: nil, status: "Status")
      allow(Jobvite::Import).to receive(:new).and_return(import_instance)
      bulk_import = described_class.new(users)

      bulk_import.import

      expect(Jobvite::Import).to have_received(:new).with(first_user)
      expect(Jobvite::Import).to have_received(:new).with(second_user)
      expect(import_instance).to have_received(:import).twice
      expect(bulk_import.status).to eq(
        1 => "Status",
        2 => "Status",
      )
    end
  end
end
