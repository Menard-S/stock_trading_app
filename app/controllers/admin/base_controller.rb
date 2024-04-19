class Admin::BaseController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

end
