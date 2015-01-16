require "rails_helper"
describe Hipchat::Users do
  before do
    stub_request(:get, "https://api.hipchat.com/v2/user")
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/hipchat_user_list.json"))
  end

  before do
    stub_request(:get, "https://api.hipchat.com/v2/user/1")
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/hipchat_user_1.json"))
  end
  before do
    stub_request(:get, "https://api.hipchat.com/v2/user/2")
      .to_return(status: 200, body: File.read("spec/fixtures/api_responses/hipchat_user_2.json"))
  end

  describe "#email_list" do
    subject { described_class.new('test').email_list }

    it { expect(subject).to eq(['test1@example.com', 'test2@example.com']) }
  end

  describe "#create_user" do
    before do
      stub_request(:post, "https://api.hipchat.com/v2/user")
        .to_return(status: 201, body: File.read("spec/fixtures/api_responses/hipchat_create_user.json"))
    end

    subject { described_class.new('test').create_user(name: 'Test', email: 'test@example.com') }

    it { expect(subject).to eq(1) }
  end
end
