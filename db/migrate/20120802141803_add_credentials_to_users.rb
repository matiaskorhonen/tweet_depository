class AddCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credentials, :text
  end
end
