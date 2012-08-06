class User < ActiveRecord::Base
  serialize :raw_auth_hash
  serialize :credentials

  has_many :statuses, dependent: :destroy

  def twitter_url
    URI::HTTPS.build({
      host: "twitter.com",
      path: "/#{self.name}"
    }).to_s
  end

  def avatar_url
    self.raw_auth_hash["profile_image_url_https"]
  end

  def display_name
    self.raw_auth_hash["name"]
  end

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    if user
      user.raw_auth_hash = auth["extra"]["raw_info"].to_hash
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
