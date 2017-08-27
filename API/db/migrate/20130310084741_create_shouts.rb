class CreateShouts < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.string 'message', :limit => 130
      t.string 'reference_name'
      t.integer 'referenced_group_id'
      t.integer 'referenced_party_id'
      t.integer 'referenced_place_id'
      t.string 'shout_type'
      t.integer 'group_id'
      t.integer 'place_id'
      t.integer 'service_id'
      t.integer 'user_id'
      t.timestamps
    end
  end
  def down
    drop_table :shouts
  end
end
