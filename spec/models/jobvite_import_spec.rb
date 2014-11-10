require "rails_helper"

describe JobviteImport do
  describe "#import" do
    context "with a connected JobviteConnection" do
      it "passes hired Jobvite candidates to the NamelyImporter and set the status" do
        connection = double("JobviteConnection", connected?: true)
        namely_connection = double("Namely::Connection")
        recent_hires = [double("hire")]
        jobvite_client = double("JobviteClient", recent_hires: recent_hires)
        namely_importer = double("NamelyImporter", import: true)
        import = described_class.new(
          connection,
          jobvite_client: jobvite_client,
          namely_importer: namely_importer,
          namely_connection: namely_connection,
        )

        import.import

        expect(import.status).
          to eq t("jobvite_import.status.candidates_imported", count: 1)
        expect(jobvite_client).to have_received(:recent_hires).with(connection)
        expect(namely_importer).to have_received(:import).with(
          recent_hires: recent_hires,
          namely_connection: namely_connection,
          attribute_mapper: instance_of(JobviteImport::AttributeMapper),
        )
      end
    end

    context "when the Jobvite API request fails" do
      it "sets the status to the Jobvite error message" do
        connection = double("JobviteConnection", connected?: true)
        namely_connection = double("Namely::Connection")
        recent_hires = [double("hire")]
        jobvite_client = double("JobviteClient")
        allow(jobvite_client).
          to receive(:recent_hires).
          and_raise(JobviteClient::Error, "Everything is broken")
        namely_importer = double("NamelyImporter")
        import = described_class.new(
          connection,
          namely_connection: namely_connection,
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

    context "with a disconnected JobviteConnection" do
      it "does nothing and sets an appropriate status" do
        connection = double("JobviteConnection", connected?: false)
        import = described_class.new(
          connection,
          namely_connection: double("Namely::Connection"),
        )

        expect { import.import }.not_to raise_exception

        expect(import.status).to eq t("jobvite_import.status.not_connected")
      end
    end
  end
end
