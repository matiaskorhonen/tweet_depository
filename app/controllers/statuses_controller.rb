class StatusesController < ApplicationController
  def index
    if user
      @oldest = user.statuses.oldest
      @newest = user.statuses.newest

      @statuses = user.statuses.order_by_sid
      @cache_name = ["statuses", "recent"]

      if params[:month]
        begin
          @date = Date.strptime("#{params[:month]}-01", "%Y-%m-%d")
          @statuses = @statuses.where("tweeted_at >= ? AND tweeted_at <= ?", @date.beginning_of_month, @date.end_of_month)
          @cache_name = ["statuses", @date.strftime("%Y-%m")]
        rescue ArgumentError => e
        end
      end

      unless @date
        @statuses = @statuses.limit(50)
      end
    else
      render template: "statuses/unauthenticated"
    end
  end

  def search
    if user && params[:q]
      @oldest = user.statuses.oldest
      @newest = user.statuses.newest
    
      @statuses = user.statuses.search(params[:q])
      @statuses = @statuses.limit(500) unless params[:bypass_limit]
      render template: "statuses/index"
    else
      redirect_to root_path
    end
  end

  private

  def user
    @user ||= if public_timeline? && User.exists?
      User.first
    elsif current_user
      current_user
    end
  end
end
