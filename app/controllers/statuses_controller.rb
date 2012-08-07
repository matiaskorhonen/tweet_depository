class StatusesController < ApplicationController
  def index
    if current_user
      @statuses = current_user.statuses.limit(10)
      @statuses = @statuses.limit(params[:limit].to_i) if params[:limit]
    else
      render template: "statuses/unauthenticated"
    end
  end
end
