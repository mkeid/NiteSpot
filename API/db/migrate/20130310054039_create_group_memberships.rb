class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
    t.boolean 'accepted', :default => true
    t.boolean 'is_admin'
	  t.references :user
	  t.references :group 
    t.timestamps
    end
	  add_index :group_memberships, ['user_id', 'group_id']
  end
  def down
    drop_table :group_memberships
  end
end
