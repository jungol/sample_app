require 'spec_helper'

describe UserMailer do

  describe "password_reset" do
  	let(:user) { FactoryGirl.create(:user, password_reset_token: "token") }
  	let(:mail) { UserMailer.password_reset(user) }

  	it "sends user password reset url" do
  	  expect(mail.subject).to eq("Password Reset")
  	  expect(mail.to).to eq([user.email])
  	  expect(mail.from).to eq(["ethanbarhydt@gmail.com"])
  	  expect(mail.body.encoded).to match(edit_password_reset_path(user.password_reset_token))
  	end
  end

  describe "account_confirmation" do
    let(:user) { FactoryGirl.create(:user, account_confirmation_token: "token")}
    let(:mail) { UserMailer.account_confirmation(user) }

    it "sends account_confirmation token" do
      expect(mail.subject).to eq("Account Confirmation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["ethanbarhydt@gmail.com"])
      expect(mail.body).to have_content(user.account_confirmation_token)
      expect(mail.body.encoded).to match(new_account_confirmation_path)
    end
  end
end
