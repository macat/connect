class HomepagesController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def show
    if logged_in?
      redirect_to dashboard_path
    end
  end
end
