require 'spec_helper'

describe "AccountConfirmations" do
  
  it "emails user when submitting sign up" do
    visit signup_path
    fill_in "Name",             with: "Example User"
    fill_in "Email",            with: "user@example.com"
    fill_in "Password",         with: "foobar"
    fill_in "Confirm Password", with: "foobar"
    click_button "Create"
    expect(current_path).to eq(user_path(User.find_by_email("user@example.com")))
    expect(page).to have_content("Check your email")
    expect(last_email.to).to include("user@example.com")
  end

  it "confirms user when account token matches" do
  	user = FactoryGirl.create(:user, account_confirmation_token: "token" )
  	visit new_account_confirmation_path
  	fill_in "account_confirmation", with: "invalid"
  	click_button "Confirm"
  	expect(current_path).to eq(account_confirmations_path)
  	expect(page).to have_content("Token invalid")
  	fill_in "account_confirmation", with: user.account_confirmation_token
  	click_button "Confirm"
  	expect(current_path).to eq(root_path)
  	expect(page).to have_content("account confirmed")
  	expect(user.reload.confirmed).to eq(true)
  end
end


