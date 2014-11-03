require "rails_helper"

describe DashboardsController do
  describe "#show" do
    context "when not logged in" do
      it "redirects to the root URL" do
        get :show

        expect(response).to redirect_to root_path
      end
    end
  end
end
