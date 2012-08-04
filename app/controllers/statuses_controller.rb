class StatusesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @statuses = current_user.statuses
    @statuses = @statuses.limit(params[:limit].to_i) if params[:limit]
  end
end
