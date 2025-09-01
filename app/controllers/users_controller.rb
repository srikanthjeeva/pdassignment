class UsersController < ApplicationController
  rescue_from PagerDutyError, with: :handle_pagerduty_error

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def handle_pagerduty_error(error)
    flash[:error] = error.message
    redirect_back(fallback_location: root_path)
  end
end
