class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.text   :raw_auth_hash

      t.timestamps
    end
    add_index :users, :provider
    add_index :users, :uid, :unique => true
    add_index :users, :name
  end
end
