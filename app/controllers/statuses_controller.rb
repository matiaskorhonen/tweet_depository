class StatusesController < ApplicationController
  def index
    if current_user
      @oldest = current_user.statuses.oldest
      @newest = current_user.statuses.newest

      @statuses = current_user.statuses.limit(200)

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
