class ChangeTwitterIdsToIntegers < ActiveRecord::Migration
  def up
    change_column :statuses, :twitter_id, :integer, limit: 8
  end

  def down
    change_column :statuses, :twitter_id, :string
  end
end