module StatusesHelper
  include Twitter::Autolink

  def format_status_text(status)
    auto_link_with_json(status.text, status.raw_hash[:entities]).html_safe
  end
end
