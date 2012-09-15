class ConvertUserUidsToBigInts < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      User.connection.execute('ALTER TABLE users ALTER uid TYPE BIGINT USING uid::bigint;')
    else
      change_column :users, :uid, :integer, limit: 8
    end
  end

  def down
    change_column :users, :uid, :string
  end
end
