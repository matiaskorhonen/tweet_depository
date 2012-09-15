class ChangeTwitterIdsToIntegers < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      Status.connection.execute('ALTER TABLE statuses ALTER twitter_id TYPE BIGINT USING twitter_id::bigint;')
    else
      change_column :statuses, :twitter_id, :integer, limit: 8
    end
  end

  def down
    change_column :statuses, :twitter_id, :string
  end
end