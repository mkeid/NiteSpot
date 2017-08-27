class CreateCabs < ActiveRecord::Migration
  def change
    create_table :cabs do |t|
      t.string 'name'
      t.integer 'phone_number'
      t.integer 'school_id'
      t.timestamps
    end
  end
end
