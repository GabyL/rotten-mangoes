class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  
  def rekt_email(user)
    @user = user
    mail(to: @user.email, subject: 'You just got destroyed and are not a user anymore get rekt lol')
  end

end
