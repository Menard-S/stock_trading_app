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
end
  