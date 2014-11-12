require "rails_helper"

describe NamelyImporter do
  describe "#import" do
    it "creates a Namely profile for each recent hire" do
      namely_connection = namely_connection_double
      recent_hires_with_dupes = double("recent_hires_with_dupes")
      recent_hires = [double(
        "recent_hire",
        name_the_first: "Dade",
        name_the_last: "Murphy",
        email: "crash.override@example.com",
      )]
      duplicate_filter = double("duplicate_filter", filter: recent_hires)
      attribute_mapper = Proc.new do |original|
        {
          first_name: original.name_the_first,
          last_name: original.name_the_last,
          email: original.email,
        }
      end
      importer = described_class.new(
        recent_hires: recent_hires_with_dupes,
        namely_connection: namely_connection,
        attribute_mapper: attribute_mapper,
        duplicate_filter: duplicate_filter,
      )

      importer.import

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
    end

    it "ignores recent hires with no email address" do
      namely_connection = namely_connection_double
      recent_hires = [{ first_name: "Dade", last_name: "Murphy", email: "" }]
      duplicate_filter = double("duplicate_filter", filter: recent_hires)
      importer = described_class.new(
        recent_hires: recent_hires,
        namely_connection: namely_connection,
        attribute_mapper: -> (original) { original },
        duplicate_filter: duplicate_filter,
      )

      importer.import

      expect(namely_connection.profiles).not_to have_received(:create!)
    end
  end

  def namely_connection_double
    profile = double("Namely::Model")
    profiles = double("Namely::Collection", create!: profile)
    double("Namely::Connection", profiles: profiles)
  end
end
