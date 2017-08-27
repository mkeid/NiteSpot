class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    t.boolean 'active', :default => false
	  t.string 'activation_token'
    t.string 'email', :limit => 100
	  t.string 'gender', :limit => 6
	  t.string 'handle', :limit => 25
    t.string 'password'
    t.integer 'party_id'
	  t.integer 'place_id'
	  t.string 'salt'
	  t.integer 'school_id'
    t.string 'name_first', :limit =>20
    t.string 'name_last', :limit =>20
	  t.string 'privacy', :limit => 7
	  t.string 'year', :limit => 9
    t.timestamps
    end
  end
  def down
    drop_table :users
  end
end
