class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer 'from_group'
      t.integer 'from_user'
      t.string 'request_type'
      t.string 'group_id'
      t.integer 'user_id'
      t.timestamps
    end
  end
  def down
    drop_table :requests
  end
end
