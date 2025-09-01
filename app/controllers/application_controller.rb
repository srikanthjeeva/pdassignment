require_relative "../errors/pager_duty_error"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from PagerDutyError, with: :handle_pager_duty_error

  private

  def handle_pager_duty_error(error)
    flash[:error] = error.message
    redirect_back(fallback_location: common_error_path)
  end
end
