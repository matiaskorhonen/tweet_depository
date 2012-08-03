module StatusesHelper
  include Twitter::Autolink

  def format_status_text(status)
    if status.is_retweet?
      auto_link_with_json(status.raw_hash[:retweeted_status][:text], status.raw_hash[:retweeted_status][:entities]).html_safe
    else
      auto_link_with_json(status.text, status.raw_hash[:entities]).html_safe
    end
  end
end
