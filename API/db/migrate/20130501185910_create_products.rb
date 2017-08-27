class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer 'cost'
      t.integer 'group_id'
      t.string 'label'
      t.string 'name'
      t.timestamps
    end
  end
end
