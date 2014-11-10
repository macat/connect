require "rails_helper"

describe NamelyImporter do
  describe "#import" do
    it "creates a Namely profile for each recent hire" do
      profile = double("Namely::Model")
      profiles = double("Namely::Collection", create!: profile)
      namely_connection = double("Namely::Connection", profiles: profiles)
      recent_hires = [double(
        "recent_hire",
        name_the_first: "Dade",
        name_the_last: "Murphy",
        email: "crash.override@example.com",
      )]
      attribute_mapper = Proc.new do |original|
        {
          first_name: original.name_the_first,
          last_name: original.name_the_last,
          email: original.email,
        }
      end
      importer = described_class.new(
        recent_hires: recent_hires,
        namely_connection: namely_connection,
        attribute_mapper: attribute_mapper,
      )

      importer.import

      expect(profiles).to have_received(:create!).with(
        first_name: "Dade",
        last_name: "Murphy",
        email: "crash.override@example.com",
      )
    end
  end
end
