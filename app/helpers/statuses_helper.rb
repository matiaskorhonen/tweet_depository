module StatusesHelper
  include Twitter::Autolink

  def format_status_text(status)
    text, entities = if status.is_retweet?
      [status.raw_hash[:retweeted_status][:text], status.raw_hash[:retweeted_status][:entities]]
    else
      [status.text, status.raw_hash[:entities]]
    end
    auto_link_with_json(text, entities, { username_include_symbol: true }).html_safe
  end
end
