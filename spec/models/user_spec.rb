require "rails_helper"

describe User do
  describe "associations" do
    it { should have_one(:jobvite_connection) }
    it { should have_one(:icims_connection) }
    it { should have_one(:net_suite_connection) }
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

  describe "#net_suite_connection" do
    context "with an existing connection" do
      it "returns the existing connection" do
        user = create(:user)

        net_suite_connection = create(:net_suite_connection, user: user)

        expect(user.net_suite_connection).to eq net_suite_connection
      end
    end

    context "with no existing connection" do
      it "creates a new connection" do
        user = create(:user)

        net_suite_connection = user.net_suite_connection

        expect(net_suite_connection).to be_a NetSuite::Connection
        expect(net_suite_connection).to be_persisted
        expect(net_suite_connection.user_id).to eq user.id
      end
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

  describe '#save_token_info' do 
    let(:user) { create :user }

    it 'saves new access token and access token expires in info' do 
      user.save_token_info('new_token', 'new_time')

      expect(user.access_token).to eql 'new_token'
    end
  end
end
