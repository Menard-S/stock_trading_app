class UserMailer < ApplicationMailer
  default from: 'menard.segeunza@gmail.com'

  def pending_approval(user)
      @user = user
      mail(to: @user.email, subject: 'Account pending admin approval')
  end

  def account_activation(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been activated')
  end

  # def invitation_link(user)
  #   @user = user
  #   mail(to: @user.email, subject: "Invitation to join our trading platform")
  # end
  def invitation_email(user)
    @user = user
    @url = edit_user_password_url(@user, reset_password_token: @user.reset_password_token)
    mail(to: @user.email, subject: 'Invitation to Stock Trading App')
  end
end
  