class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
	  t.string "email", :limit => 25
	  t.string "handle", :limit => 25
    t.string "label"
	  t.string "name"
	  t.boolean "owned", :default => false
	  t.string "password", :limit => 40
	  t.string "phone_number", :limit => 20
	  t.string "salt", :limit => 100
    t.timestamps
    end
	add_index :services, :handle
  end
end
