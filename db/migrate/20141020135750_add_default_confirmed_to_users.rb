class AddDefaultConfirmedToUsers < ActiveRecord::Migration
  def change
  	change_column :users, :confirmed, :boolean, default: false
  end
end
