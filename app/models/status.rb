class Status < ActiveRecord::Base
  serialize :raw_hash

  belongs_to :user

  attr_accessible :in_reply_to_screen_name, :in_reply_to_user_id, :raw_hash, :source, :text, :tweeted_at, :twitter_id
  
  def self.statuses_for_user(user_id, options = {})
    user = User.find(user_id)
    user.client.user_timeline(user.name, options)
  end
end
