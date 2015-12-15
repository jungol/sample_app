class AddAccountConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_confirmation_token, :string
  end
end
