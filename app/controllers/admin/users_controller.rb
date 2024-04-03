class Admin::UsersController < Admin::BaseController
  def activate_user
    user = User.find(params[:id])
    if user.update(status: :approved)
      UserMailer.account_activation(user).deliver_now
      redirect_to admin_dashboard_path, notice: "User activated successfully and notification sent."
    else
      redirect_to admin_dashboard_path, alert: "There was a problem activating the user."
    end
  end
end