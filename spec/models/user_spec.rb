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
    it "returns the existing Jobvite::Connection when one exists" do
      user = create(:user)

      jobvite_connection = create(:jobvite_connection, user: user)

      expect(user.jobvite_connection).to eq jobvite_connection
    end

    it "creates a new Jobvite::Connection when one doesn't exist" do
      user = create(:user)

      jobvite_connection = user.jobvite_connection

      expect(jobvite_connection).to be_a Jobvite::Connection
      expect(jobvite_connection).to be_persisted
      expect(jobvite_connection.user_id).to eq user.id
    end
  end

  describe "#namely_connection" do
    it "returns a Namely::Connection configured to use the user's credentials" do
      namely_connection = double("Namely::Connection")
      allow(Namely::Connection).to receive(:new).and_return(namely_connection)
      user = build(
        :user,
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

  describe "#fresh_access_token" do
    context "when the access token is still valid" do
      it "returns the old access token" do
        user = build(
          :user,
          access_token_expiry: 5.minutes.from_now
        )
        old_access_token = user.access_token

        token = user.fresh_access_token

        expect(token).to eq old_access_token
      end
    end

    context "when the access token has expired" do
      it "refreshes the access token and returns the new one" do
        old_access_token = "my-old-access-token"
        new_access_token = "my-new-access-token"
        expiry_time = 899
        user = build(
          :user,
          access_token: old_access_token,
          access_token_expiry: 5.minutes.ago,
        )
        authenticator = double(
          "authenticator",
          refresh_access_token:  {
            "access_token" => new_access_token,
            "expires_in" => expiry_time.to_s,
          }
        )

        token = user.fresh_access_token(authenticator)

        expect(token).to eq new_access_token
        expect(user.access_token).to eq new_access_token
        expect(user.access_token_expiry).
          to be_within(1.second).of(expiry_time.seconds.from_now)
      end
    end
  end

  describe "#access_token_expires_in" do
    it "sets the expiry time that many seconds in the future" do
      expiry_time = 899
      user = build(:user)

      user.access_token_expires_in = expiry_time

      expect(user.access_token_expiry).
        to be_within(1.second).of(expiry_time.seconds.from_now)
    end
  end
end
