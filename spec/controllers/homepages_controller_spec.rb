require "rails_helper"

describe HomepagesController do
  describe "#show" do
    context "when logged in" do
      it "redirects to the dashboard" do
        session[:current_user_id] = create(:user).id

        get :show

        expect(response).to redirect_to dashboard_path
      end
    end

    context "when not logged in" do
      it "renders the public home page" do
        get :show

        expect(response).to render_template "homepages/show"
      end
    end
  end
end
