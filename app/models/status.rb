require "uri"

class Status < ActiveRecord::Base
  serialize :raw_hash

  belongs_to :user

  default_scope order("tweeted_at DESC")

  def twitter_url
    URI::HTTPS.build({
      host: "twitter.com",
      path: "/#{self.screen_name}/status/#{self.twitter_id}"
    }).to_s
  end

  def screen_name
    self.raw_hash[:user][:screen_name]
  end

  def self.create_from_hash(hash = {}, user_id = nil)
    unless user_id
      user = User.where(name: hash[:user][:screen_name]).select(:id).first
      user_id = user.id
    end
    self.find_or_create_by_twitter_id(hash[:id_str]) do |status|
      status.user_id                 = user_id
      status.text                    = hash[:text]
      status.source                  = hash[:source]
      status.tweeted_at              = hash[:created_at]
      status.in_reply_to_screen_name = hash[:in_reply_to_screen_name]
      status.in_reply_to_user_id     = hash[:in_reply_to_user_id]
      status.raw_hash                = hash
    end
  end

  def self.statuses_for_user(user, options = {})
    user.client.user_timeline(user.name, options)
  end

  def self.initial_import_for_user(user_id)
    @max_id = nil
    @current_user = User.find(user_id)
    loop do
      options = {
        count: 200,
        include_rts: true,
        exclude_replies: false,
        contributor_details: true,
        include_entities: true
      }

      if @max_id.present?
        options[:max_id] = @max_id
      end

      statuses = self.statuses_for_user(@current_user, options)

      break if statuses.count == 0 || statuses.last.id.to_s == @max_id

      statuses.each do |status|
        self.create_from_hash(status.to_hash, user_id)
      end

      @max_id = statuses.last[:id].to_s
    end
  end
end
