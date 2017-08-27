class CreateUserFavorites < ActiveRecord::Migration
  def change
    create_table :user_favorites do |t|
      t.integer 'cab_id'
      t.integer 'service_id'
      t.integer 'user_id'
      t.timestamps
    end
  end
  def fown
    drop_table :user_favorites
  end
end
