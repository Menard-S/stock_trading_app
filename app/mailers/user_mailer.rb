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

  def user_invitation(user, invitation_link)
    @user = user
    @invitation_link = invitation_link
    mail(to: @user.email, subject: 'Invitation to join EquiSphere')
  end
end
  