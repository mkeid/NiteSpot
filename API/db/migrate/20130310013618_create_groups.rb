class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
	  t.string 'handle', :limit => 25
	  t.string 'name'
	  t.string 'group_type'
	  t.boolean 'public', :default => true
    t.integer 'school_id'
    t.string 'avatar_file_name'
    t.string 'avatar_content_type'
    t.integer ':avatar_file_size'
    t.timestamps
    end
	add_index :groups, :handle
  end
  def down
    drop_index :groups, :handle
    drop_table :groups
  end
end
