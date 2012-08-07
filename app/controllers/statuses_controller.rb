class StatusesController < ApplicationController
  def index
    if current_user
      @statuses = current_user.statuses.limit(200)
      limit = params[:limit].to_i > 0 ? params[:limit].to_i : 200
      @statuses = @statuses.limit(limit)
    else
      render template: "statuses/unauthenticated"
    end
  end
end
