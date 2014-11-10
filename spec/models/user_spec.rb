require "rails_helper"

describe User do
  describe "associations" do
    it { should have_one(:jobvite_connection) }
  end

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

  describe "#jobvite_connection" do
    it "returns the existing JobviteConnection when one exists" do
      user = create(:user)

      jobvite_connection = create(:jobvite_connection, user: user)

      expect(user.jobvite_connection).to eq jobvite_connection
    end

    it "creates a new JobviteConnection when one doesn't exist" do
      user = create(:user)

      jobvite_connection = user.jobvite_connection

      expect(jobvite_connection).to be_a JobviteConnection
      expect(jobvite_connection).to be_persisted
      expect(jobvite_connection.user_id).to eq user.id
    end
  end

  describe "#namely_connection" do
    it "returns a Namely::Connection configured to use the user's credentials" do
      namely_connection = double("Namely::Connection")
      allow(Namely::Connection).to receive(:new).and_return(namely_connection)
      user = described_class.new(
        access_token: "MY_ACCESS_TOKEN",
        subdomain: "ellingsonmineral",
      )

      result = user.namely_connection

      expect(result).to eq namely_connection
      expect(Namely::Connection).to have_received(:new).with(
        access_token: "MY_ACCESS_TOKEN",
        subdomain: "ellingsonmineral",
      )
    end
  end
end
