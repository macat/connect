require "rails_helper"
describe Hipchat::Users do
  describe "#email_list" do
    subject { described_class.new('test').email_list }

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

    it { expect(subject).to eq(['test1@example.com', 'test2@example.com']) }
  end
end
