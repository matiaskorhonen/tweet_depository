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

  def update_from_twitter!
    user_hash = client.user(self.uid).to_hash
    self.raw_auth_hash = HashWithIndifferentAccess.new(user_hash)
    self.save!
  end

  def client
    @client ||= begin
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_KEY"]
        config.consumer_secret = ENV["TWITTER_SECRET"]
        config.access_token = credentials["token"]
        config.access_token_secret = credentials["secret"]
      end
    end
  end
end
