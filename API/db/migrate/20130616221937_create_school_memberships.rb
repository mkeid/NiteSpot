class CreateSchoolMemberships < ActiveRecord::Migration
  def change
    create_table :school_memberships do |t|
      t.integer 'school_id'
      t.integer 'user_id'
      t.boolean 'is_primary', :default => false
      t.timestamps
    end
  end
end
