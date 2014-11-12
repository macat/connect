require "rails_helper"

describe Jobvite::BulkImport do
  describe "#import" do
    it "imports Jobvite candidates for each of the users" do
      first_user = double(
        "user",
        namely_user_id: "Dade",
        subdomain: "crash-override",
      )
      second_user = double(
        "user",
        namely_user_id: "Kate",
        subdomain: "acid-burn",
      )
      users = [first_user, second_user]
      import_instance = double("import_instance", import: "Status")
      allow(Jobvite::Import).to receive(:new).and_return(import_instance)
      bulk_import = described_class.new(users)

      status = bulk_import.import

      expect(Jobvite::Import).to have_received(:new).with(first_user)
      expect(Jobvite::Import).to have_received(:new).with(second_user)
      expect(import_instance).to have_received(:import).twice
      expect(status).to be_an ImportResult
      expect(status[first_user]).to eq "Status"
      expect(status[second_user]).to eq "Status"
      expect(status.to_s).
        to eq "User Dade (crash-override): Status\nUser Kate (acid-burn): Status\n"
    end
  end
end
