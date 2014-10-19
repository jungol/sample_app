require 'spec_helper'

describe "PasswordResets" do
    # let(:user) { FactoryGirl.create(:user) }

  it "emails user when requesting password reset" do
  	user = FactoryGirl.create(:user)
    visit signin_path
  	click_link "Reset Password"
  	fill_in "Email", :with => user.email
  	click_button "Reset Password"
  	expect(current_path).to eq(root_path)
  	expect(page).to have_content("Check your inbox for instructions to reset your password")
  	expect(last_email.to).to include(user.email)

  end

  it "does not email invalid user when requesting password reset" do
    visit signin_path
    click_link "Reset Password"
    fill_in "Email", :with => "invalid"
    click_button "Reset Password"
    expect(current_path).to eq(password_resets_path)
    expect(page).to have_content("Please enter a valid email address!")
    expect(last_email).to be_nil
  end

  it "updates the password when confirmation matches" do
    user = FactoryGirl.create(:user, password_reset_token: "token", 
                              password_reset_sent_at: 1.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)                            
    fill_in "Password", with: "foobar"
    fill_in "Confirm Password", with: "barfoo"
    click_button "Update Password"
    expect(current_path).to eq(password_reset_path(user.password_reset_token))
    expect(page).to have_content("Password confirmation doesn't match Password")
    fill_in "Password", with: "foobar"
    fill_in "Confirm Password", with: "foobar"
    click_button "Update Password"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Password has been reset!")
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, password_reset_token: "token",
                              password_reset_sent_at: 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "Password", with: "foobar"
    fill_in "Confirm Password", with: "foobar"
    click_button "Update Password"
    expect(current_path).to eq(new_password_reset_path)
    expect(page).to have_content("Password reset has expired")
  end

  it "raises record not found when password token is invalid" do
    expect do
      visit edit_password_reset_path("invalid")
    end.to raise_exception(ActiveRecord::RecordNotFound)
  end


end