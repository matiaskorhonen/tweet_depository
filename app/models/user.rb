class User < ActiveRecord::Base
  serialize :raw_auth_hash

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    if user
      user.raw_auth_hash = auth["extra"]["raw_info"]
      user.save
    end
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.raw_auth_hash = auth["extra"]["raw_info"]
    end
  end
end
