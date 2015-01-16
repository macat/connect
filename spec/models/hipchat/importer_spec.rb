require "rails_helper"

describe Hipchat::Importer do
  let(:email_list) { [] }
  let(:namely_profiles) { [] }
  let(:hipchat_users) { double(:hipchat_users, email_list: email_list) }
  let(:token) { "test" }
  let(:namely_connection) { double(:namely_connection) }
  let(:importer) { described_class.new(token: token, namely_connection: namely_connection) }

  before do
    allow(importer).to receive(:hipchat_users) do
      hipchat_users
    end
    allow(importer).to receive(:namely_profiles) do
      namely_profiles
    end
  end


  context "when one new user" do
    let(:email_list) { ['a@b.com'] }
    let(:namely_profiles) { [
      double(:p, first_name: 'A', last_name: 'B', email: 'a@b.com'),
      double(:p, first_name: 'C', last_name: 'D', email: 'c@d.com'),
    ]}

    it "creates a new user" do
      expect(hipchat_users).to receive(:create_user).with(name: 'C D', email: 'c@d.com')
      importer.import
    end
  end

end
