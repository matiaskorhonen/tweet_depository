class StatusObserver < ActiveRecord::Observer
  observe :status

  def after_destroy(status)
    expire_fragments(status, force: true)
  end

  def expire_fragments(status, options={})
    if Status.order_by_sid.limit(50).where(id: status.id).exists? || options[:force]
      expire_fragment ["statuses", "recent"]
    end
    expire_fragment ["statuses", status.tweeted_at.strftime("%Y-%m")]
  end

  alias_method :after_save, :expire_fragments

  private

  def method_missing(method, *arguments, &block)
    @controller ||= ActionController::Base.new
    @controller.__send__(method, *arguments, &block)
  end
end
