require "rails_helper"

describe Session do
  describe "delegations" do
    subject do
      described_class.new(
        double("authenticator"),
        code: "an-auth-code",
        subdomain: "a-subdomain",
      )
    end

    it { should delegate_method(:user_id).to(:user).as(:id) }
  end

  describe "#user" do
    context "for a new User" do
      it "creates and returns a User" do
        authenticator = authenticator_double(
          namely_user_id: "a-namely-user",
          access_token: "my-access-token",
          refresh_token: "my-refresh-token",
        )
        session = described_class.new(
          authenticator,
          code: "my-code",
          subdomain: "my-subdomain",
        )

        user = session.user

        expect(user.namely_user_id).to eq "a-namely-user"
        expect(user.subdomain).to eq "my-subdomain"
        expect(user.access_token).to eq "my-access-token"
        expect(user.refresh_token).to eq "my-refresh-token"
        expect(user.first_name).to eq "Eugene"
        expect(user.last_name).to eq "Belford"
        expect(user).to be_persisted
        expect(authenticator).to have_received(:retrieve_tokens).with(
          code: "my-code",
          subdomain: "my-subdomain",
          redirect_uri: Rails.configuration.namely_authentication_redirect_uri,
        )
        expect(authenticator).to have_received(:current_user).with(
          access_token: "my-access-token",
          subdomain: "my-subdomain",
        )
      end
    end

    context "for a returning User" do
      it "updates and returns a User" do
        existing_user = create(
          :user,
          namely_user_id: "a-namely-user",
          subdomain: "my-subdomain",
          access_token: "old-access-token",
          refresh_token: "old-refresh-token",
        )
        authenticator = authenticator_double(
          namely_user_id: existing_user.namely_user_id,
          access_token: "new-access-token",
          refresh_token: "new-refresh-token",
        )
        session = described_class.new(
          authenticator,
          code: "my-code",
          subdomain: "my-subdomain",
        )

        user = session.user

        existing_user.reload
        expect(user).to eq existing_user
        expect(existing_user.access_token).to eq "new-access-token"
        expect(existing_user.refresh_token).to eq "new-refresh-token"
      end
    end
  end

  def authenticator_double(namely_user_id:, access_token:, refresh_token:)
    namely_profile = double(
      "Profile",
      id: namely_user_id,
      first_name: "Eugene",
      last_name: "Belford",
    )
    double(
      "Namely::Authenticator",
      retrieve_tokens: {
        "access_token" => access_token,
        "expires_in" => 899,
        "refresh_token" => refresh_token,
        "token_type" => "bearer",
      },
      current_user: namely_profile,
    )
  end
end
