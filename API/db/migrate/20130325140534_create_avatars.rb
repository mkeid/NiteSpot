class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string 'location'
      t.integer 'group_id'
      t.integer 'place_id'
      t.integer 'service_id'
      t.integer 'user_id'

      t.timestamps
    end
  end
  def down
    drop_table :avatars
  end
end
