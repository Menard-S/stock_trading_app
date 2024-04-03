class Admin::DashboardController < Admin::BaseController
  def index
    @pending_users = User.where(status: :pending)
  end
end
