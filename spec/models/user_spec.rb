require "rails_helper"

describe User do
  describe "#full_name" do
    it "combines the first and last names" do
      user = described_class.new(first_name: "Kate", last_name: "Libby")

      expect(user.full_name).to eq "Kate Libby"
    end

    context "when only one name is set" do
      it "returns that name" do
        expect(described_class.new(first_name: "Kate").full_name).to eq "Kate"
        expect(described_class.new(last_name: "Libby").full_name).to eq "Libby"
      end
    end

    context "when no names are set" do
      it "returns the empty string" do
        expect(described_class.new.full_name).to eq ""
      end
    end
  end
end
