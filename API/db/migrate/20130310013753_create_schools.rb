class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
	  t.string "email_extension"
	  t.string "handle", :limit => 25
	  t.string "name"
      t.timestamps
    end
	add_index :schools, :handle
  end
end
