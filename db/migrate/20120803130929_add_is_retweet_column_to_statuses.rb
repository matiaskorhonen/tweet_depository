class AddIsRetweetColumnToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :is_retweet, :boolean
  end
end
