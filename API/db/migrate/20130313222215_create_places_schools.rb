class CreatePlacesSchools < ActiveRecord::Migration
  def change
    create_table :places_schools, :id => false do |t|
	  t.integer "place_id"
	  t.integer "school_id"
	  t.timestamps
	end
  end
end
