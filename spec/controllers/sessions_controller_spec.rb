require "rails_helper"

describe SessionsController do
  describe "#destroy" do
    it "logs the user out and redirects to the root URL" do
      session[:current_user_id] = 123

      delete :destroy

      expect(response).to redirect_to root_url
      expect(session[:current_user_id]).to be_nil
    end
  end
end
