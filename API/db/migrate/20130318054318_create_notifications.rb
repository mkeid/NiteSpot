class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    t.integer 'from_group'
    t.integer 'from_party'
    t.integer 'from_user'
	  t.string 'message'
    t.boolean 'unchecked', :default=> true
    t.string 'notification_type'
    t.string 'shout_liked'

    t.integer 'group_id'
	  t.integer 'place_id'
	  t.integer 'service_id'
	  t.integer 'user_id'

    t.timestamps
    end
  end
  def down
    drop_table :notifications
  end
end
