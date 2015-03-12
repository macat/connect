require "rails_helper"

describe NamelyImporter do
  describe "#import" do
    it "creates a Namely profile for each recent hire" do
      namely_connection = namely_connection_double
      recent_hires_with_dupes = double("recent_hires_with_dupes")
      candidate = double(
        "recent_hire",
        name_the_first: "Dade",
        name_the_last: "Murphy",
        email: "crash.override@example.com",
      )
      recent_hires = [candidate]
      duplicate_filter = double("duplicate_filter", filter: recent_hires)
      attribute_mapper = Proc.new do |original|
        {
          first_name: original.name_the_first,
          last_name: original.name_the_last,
          email: original.email,
        }
      end
      importer = described_class.new(
        namely_connection: namely_connection,
        attribute_mapper: attribute_mapper,
        duplicate_filter: duplicate_filter,
      )

      status = importer.import(recent_hires_with_dupes)

      expect(namely_connection.profiles).to have_received(:create!).with(
        first_name: "Dade",
        last_name: "Murphy",
        email: "crash.override@example.com",
      )
      expect(duplicate_filter).to have_received(:filter).with(
        recent_hires_with_dupes,
        namely_connection: namely_connection,
        attribute_mapper: attribute_mapper,
      )
      expect(status).to be_an ImportResult
      expect(status[candidate]).to eq t("status.success")
    end

    it "flags recent hires with no email address" do
      namely_connection = namely_connection_double
      recent_hires = [{ first_name: "Dade", last_name: "Murphy", email: "" }]
      duplicate_filter = double("duplicate_filter", filter: recent_hires)

      candidate = { first_name: "Dade", last_name: "Murphy", email: "" }
      recent_hires = [candidate]
      importer = described_class.new(
        namely_connection: namely_connection,
        attribute_mapper: -> (original) { original },
        duplicate_filter: duplicate_filter,
      )

      status = importer.import(recent_hires)

      expect(namely_connection.profiles).not_to have_received(:create!)
      expect(status).to be_an ImportResult
      expect(status[candidate]).to eq t("status.missing_required_field")
    end
  end

  def namely_connection_double
    profile = double("Namely::Model")
    profiles = double("Namely::Collection", create!: profile)
    double("Namely::Connection", profiles: profiles)
  end
end
