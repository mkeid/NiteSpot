class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
	  t.boolean "active", :default => false
	  t.string "email", :limit => 25
	  t.string "handle", :limit => 25
	  t.string "name", :limite => 20
	  t.boolean "owned", :default=> false
	  t.string "salt", :limit => 100
      t.timestamps
    end
	add_index :places, :handle
  end
end
