require "rails_helper"

describe Authenticator do
  include_context 'subdomain'
  subject { described_class.new(subdomain) }
  describe "#namely_authenticator" do
    it { expect(subject.namely_authenticator).to be_a(Namely::Authenticator) }
  end

  describe "subdomain" do
    it { expect(subject.subdomain).to eq(subdomain) }
  end

  describe "#authorization_code_url" do
    it { expect(subject.authorization_code_url('test')).to include("state=#{ subdomain }") }
    it { expect(subject.authorization_code_url('test')).to include("#{ subdomain }.namely.com") }
  end

  describe "#retrieve_tokens" do
    before do
      stub_request(:post, "https://#{ subdomain }.namely.com/api/v1/oauth2/token")
        .with(query: {redirect_uri: "http://#{ ENV['HOST'] }/session/oauth_callback"})
        .to_return(status: 200, body: JSON.dump(tokens))
    end

    let(:tokens) do
      {
        access_token: ENV['TEST_NAMELY_ACCESS_TOKEN'],
        refresh_token: ENV['TEST_NAMELY_REFRESH_TOKEN'],
        token_type: "bearer",
        expires_in: 899
      }
    end


    it do
      expect(subject.retrieve_tokens('test')['access_token']).to eq(tokens[:access_token])
    end
    it do
      expect(subject.retrieve_tokens('test')['refresh_token']).to eq(tokens[:refresh_token])
    end
  end
end
