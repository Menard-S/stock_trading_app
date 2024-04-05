class Admin::DashboardController < Admin::BaseController
  def index
    @pending_users = User.where(status: :pending)
    @approved_users = User.where(status: :approved)
  end
end
