class SchoolsServices < ActiveRecord::Migration
  def up
    create_table :schools_services do |t|
      t.integer :school_id
      t.integer :service_id
      t.timestamps
    end
  end

  def down
    drop_table :schools_services
  end
end
