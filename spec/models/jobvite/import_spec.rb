require "rails_helper"

describe Jobvite::Import do
  describe "#import" do
    context "with a connected Jobvite::Connection" do
      it "passes hired Jobvite candidates to the NamelyImporter and set the status" do
        user = double(
          "user",
          jobvite_connection: double("jobvite_connection", connected?: true),
          namely_connection: double("Namely::Connection"),
        )
        recent_hires = [double("hire")]
        jobvite_client = double("jobvite_client", recent_hires: recent_hires)
        namely_importer = double("NamelyImporter", import: true)
        import = described_class.new(
          user,
          jobvite_client: jobvite_client,
          namely_importer: namely_importer,
        )

        import.import

        expect(import.status).
          to eq t("jobvite_import.status.candidates_imported", count: 1)
        expect(jobvite_client).to have_received(:recent_hires).
          with(user.jobvite_connection)
        expect(namely_importer).to have_received(:import).with(
          recent_hires: recent_hires,
          namely_connection: user.namely_connection,
          attribute_mapper: instance_of(Jobvite::AttributeMapper),
        )
      end
    end

    context "when the Jobvite API request fails" do
      it "sets the status to the Jobvite error message" do
        user = double(
          "user",
          jobvite_connection: double("jobvite_connection", connected?: true),
          namely_connection: double("Namely::Connection"),
        )
        recent_hires = [double("hire")]
        jobvite_client = double("jobvite_client")
        allow(jobvite_client).
          to receive(:recent_hires).
          and_raise(Jobvite::Client::Error, "Everything is broken")
        namely_importer = double("NamelyImporter")
        import = described_class.new(
          user,
          jobvite_client: jobvite_client,
          namely_importer: namely_importer,
        )

        import.import

        expect(import.status).to eq t(
          "jobvite_import.status.jobvite_error",
          message: "Everything is broken",
        )
      end
    end

    context "with a disconnected Jobvite::Connection" do
      it "does nothing and sets an appropriate status" do
        user = double(
          "user",
          jobvite_connection: double("jobvite_connection", connected?: false),
          namely_connection: double("Namely::Connection"),
        )
        import = described_class.new(user)

        expect { import.import }.not_to raise_exception

        expect(import.status).to eq t("jobvite_import.status.not_connected")
      end
    end
  end
end
