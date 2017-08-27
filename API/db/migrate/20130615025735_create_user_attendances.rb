class CreateUserAttendances < ActiveRecord::Migration
  def change
    create_table :user_attendances do |t|
      t.integer 'user_id'
      t.integer 'party_id'
      t.integer 'place_id'
      t.timestamps
    end
  end
end
