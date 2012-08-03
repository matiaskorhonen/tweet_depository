class User < ActiveRecord::Base
  serialize :raw_auth_hash
  serialize :credentials

  has_many :statuses

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    if user
      user.raw_auth_hash = auth["extra"]["raw_info"]
      user.credentials = auth["credentials"]
      user.save
    end
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.credentials = auth["credentials"]
      user.raw_auth_hash = auth["extra"]["raw_info"]
    end
  end

  def client
    @client ||= begin
      Twitter.configure do |config|
        config.consumer_key = ENV["TWITTER_KEY"]
        config.consumer_secret = ENV["TWITTER_SECRET"]
        config.oauth_token = credentials["token"]
        config.oauth_token_secret = credentials["secret"]
      end
      Twitter
    end
  end
end
