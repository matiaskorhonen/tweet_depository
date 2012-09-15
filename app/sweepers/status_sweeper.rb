class StatusSweeper < ActionController::Caching::Sweeper
  observe Status

  def after_create(status)
    expire_fragment("timeline_selector")
  end
end
