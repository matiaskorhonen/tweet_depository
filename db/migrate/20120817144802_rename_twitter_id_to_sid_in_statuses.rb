class RenameTwitterIdToSidInStatuses < ActiveRecord::Migration
  def up
    remove_index :statuses, :twitter_id
    rename_column :statuses, :twitter_id, :sid
    add_index :statuses, :sid, unique: true
  end

  def down
    remove_index :statuses, :sid
    rename_column :statuses, :sid, :twitter_id
    add_index :statuses, :twitter_id, unique: true
  end
end
