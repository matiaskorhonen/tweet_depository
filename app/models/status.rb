# encoding: UTF-8
require "uri"

class Status < ActiveRecord::Base
  serialize :raw_hash

  belongs_to :user

  scope :order_by_sid, order("sid DESC")

  include PgSearch
  pg_search_scope :search,
    against: { text: "A", in_reply_to_screen_name: "B" },
    using: { tsearch: { dictionary: "english" } }

  def cache_key
    "#{sid}-#{updated_at.strftime('%Y%m%d%H%M%S')}"
  end

  def twitter_url
    URI::HTTPS.build({
      host: "twitter.com",
      path: "/#{self.screen_name}/status/#{self.sid}"
    }).to_s
  end

  def screen_name
    if raw_hash[:retweeted_status].present?
      self.raw_hash[:retweeted_status][:user][:screen_name]
    else
      self.raw_hash[:user][:screen_name]
    end
  end

  def twitter_user_url
    URI::HTTPS.build({
      host: "twitter.com",
      path: "/#{self.screen_name}"
    }).to_s
  end

  def is_reply?
    self.raw_hash[:in_reply_to_status_id].present? &&
    self.raw_hash[:in_reply_to_screen_name].present?
  end

  def in_reply_to_screen_name
    self.raw_hash[:in_reply_to_screen_name]
  end

  def in_reply_to_url
    URI::HTTPS.build({
      host: "twitter.com",
      path: "/#{raw_hash[:in_reply_to_screen_name]}/status/#{raw_hash[:in_reply_to_status_id]}"
    }).to_s
  end

  def self.oldest
    self.order("sid DESC").last
  end

  def self.newest
    self.order("sid DESC").first
  end

  def self.create_from_hash(hash = {}, user_id = nil)
    unless user_id
      user = User.where(name: hash[:user][:screen_name]).select(:id).first
      user_id = user.id
    end
    self.find_or_create_by_sid(hash[:id]) do |status|
      status.user_id                 = user_id
      status.text                    = hash[:text]
      status.source                  = hash[:source]
      status.tweeted_at              = hash[:created_at]
      status.in_reply_to_screen_name = hash[:in_reply_to_screen_name]
      status.in_reply_to_user_id     = hash[:in_reply_to_user_id]
      status.is_retweet              = !!hash[:retweeted_status]
      status.raw_hash                = hash
    end
  end

  def self.statuses_for_user(user, options = {})
    user.client.user_timeline(user.name, options)
  end

  def self.initial_import_for_user(user_id)
    self.transaction do
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

  # FIXME: This is still pretty stupid and assumes that there won't be > 200
  # new tweets…
  def self.import_latest_for_user(user_id)
    self.transaction do
      current_user = User.find(user_id)
      if current_user.statuses.any?
        options = {
          count: 200,
          include_rts: true,
          exclude_replies: false,
          contributor_details: true,
          include_entities: true,
          since_id: current_user.statuses.order_by_sid.last.sid
        }
        statuses = self.statuses_for_user(current_user, options)

        statuses.each do |status|
          self.create_from_hash(status.to_hash, user_id)
        end
      end
    end
  end
end
