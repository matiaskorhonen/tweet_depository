module StatusesHelper
  include Twitter::Autolink

  # Skip the t.co redirect if possible
  def link_to_text(entity, text, href, attributes = {}, options = {})
    href = entity[:expanded_url] if entity[:expanded_url]
    super(entity, text, href, attributes, options)
  end

  def format_status_text(status)
    text, entities = if status.is_retweet? && status.raw_hash[:retweeted_status]
      [status.raw_hash[:retweeted_status][:text], status.raw_hash[:retweeted_status][:entities]]
    elsif status.raw_hash[:entities].present?
      [status.text, status.raw_hash[:entities]]
    else
      [status.text, nil]
    end

    if entities
      auto_link_with_json(text, entities, { username_include_symbol: true }).html_safe
    else
      auto_link(text, { username_include_symbol: true }).html_safe
    end
  end

  def tweet_dates(oldest, newest)
    date_range = []

    ( (oldest.tweeted_at.to_date)..(newest.tweeted_at.to_date) ).each do |day|
      date_range << day.beginning_of_month
    end

    date_range.uniq!

    date_range = date_range.group_by { |date| date.strftime("%Y") }

    date_range.each_key do |key|
      date_range[key] = date_range[key].reverse
    end

    Hash[date_range.sort.reverse]
  end
end
