class StatusesController < ApplicationController
  def index
    puts ENV["PUBLIC_TIMELINE"].inspect
    @user = if ENV["PUBLIC_TIMELINE"] =~ /\Atrue\z/i && User.exists?
      User.first
    elsif current_user
      current_user
    end

    if @user
      @oldest = @user.statuses.oldest
      @newest = @user.statuses.newest

      @statuses = @user.statuses.limit(200)

      if params[:month] && !(params[:month] =~ /\Arecent\z/i)
        begin
          @date = Date.strptime("#{params[:month]}-01", "%Y-%m-%d")
          @statuses = @statuses.where("tweeted_at >= ? AND tweeted_at <= ?", @date.beginning_of_month, @date.end_of_month)
        rescue ArgumentError => e
        end
      end

      unless @date
        limit = params[:limit].to_i > 0 ? params[:limit].to_i : 200
        @statuses = @statuses.limit(limit)
      end
    else
      render template: "statuses/unauthenticated"
    end
  end
end
