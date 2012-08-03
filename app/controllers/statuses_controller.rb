class StatusesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @statuses = current_user.statuses
  end
end
