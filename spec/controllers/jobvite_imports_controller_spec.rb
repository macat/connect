require "rails_helper"

describe JobviteImportsController do
  describe "#create" do
    context "when not logged in" do
      it "redirects to the root URL" do
        post :create

        expect(response).to redirect_to root_path
      end
    end
  end
end
