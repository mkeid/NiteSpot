class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
	  t.string 'address'
	  t.string 'description'
	  t.string 'name'
    t.boolean 'public'
	  t.datetime 'time'
    t.integer 'group_id'
    t.timestamps
    end
  end

  def down
    drop_table :parties
  end
end
