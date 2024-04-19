class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:edit, :update]

  def edit
    @user = User.find_by(invitation_token: params[:token])
    unless @user
      redirect_to root_path, alert: "Invalid or expired invitation token."
    end
  end

  def update
    @user = User.find_by(invitation_token: params[:user][:invitation_token])

    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password, "Passwords do not match")
        flash.now[:alert] = "Passwords do not match"
      render :edit
      return
    end

    if @user.update(user_params.merge(invitation_accepted_at: Time.current, status: :approved))
      sign_in(:user, @user) if @user.persisted?
      redirect_to root_path, notice: "Your registration has been approved, and your account is now active."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :yob, :asset, :invitation_token)
  end
end
