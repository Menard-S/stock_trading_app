class AdminMailer < Devise::Mailer
  default from: 'from@example.com'
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    mail(to: 'menard.seguenza@gmail.com', subject: 'New user awaiting admin approval')
  end
end