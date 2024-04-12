class UserMailer < ApplicationMailer
  default from: 'menard.segeunza@gmail.com'

  def pending_approval(user, invited_by_admin)
    if invited_by_admin
      invitation_email
    else
      @user = user
      mail(to: @user.email, subject: 'Account pending admin approval')
    end
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
    mail(to: @user.email, subject: 'You are invited to join our platform')
  end
  
end
  