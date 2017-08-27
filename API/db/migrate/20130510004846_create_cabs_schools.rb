class CreateCabsSchools < ActiveRecord::Migration
  def change
    create_table :cabs_schools do |t|
      t.integer 'cab_id'
      t.integer 'school_id'
      t.timestamps
    end
  end
end
