class AccountConfirmationsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_account_confirmation_token(params[:account_confirmation])
  	if user.nil?
  	  flash.now[:error] = "Token invalid"
  	  render 'new'
  	elsif user.update_attribute(:confirmed, true)
  	  redirect_to root_path, :notice => "account confirmed"
  	else
  	  redirect_to users_path
  	end

  end

end
