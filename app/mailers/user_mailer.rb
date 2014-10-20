class UserMailer < ActionMailer::Base

  default from: 'ethanbarhydt@gmail.com'

  def password_reset(user)
    @user = user #for use in view
    @url = 'http://www.google.com'
    mail to: user.email, subject: "Password Reset"
  end
end
