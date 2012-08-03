class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :user
      t.string :twitter_id
      t.text :text
      t.string :source
      t.string :in_reply_to_user_id
      t.string :in_reply_to_screen_name
      t.datetime :tweeted_at
      t.text :raw_hash

      t.timestamps
    end
    add_index :statuses, :user_id
    add_index :statuses, :twitter_id, :unique => true
    add_index :statuses, :in_reply_to_user_id
    add_index :statuses, :in_reply_to_screen_name
  end
end
