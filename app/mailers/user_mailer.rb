class UserMailer < ActionMailer::Base

  default from: 'ethanbarhydt@gmail.com'

  def password_reset(user)
    @user = user #for use in view
    mail to: user.email, subject: "Password Reset"
  end

  def account_confirmation(user)
  	@user = user
  	mail to: user.email, subject: "Account Confirmation"
  end

end
