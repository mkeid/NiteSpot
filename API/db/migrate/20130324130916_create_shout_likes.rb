class CreateShoutLikes < ActiveRecord::Migration
  def change
    create_table :shout_likes do |t|
      t.integer :shout_id
      t.integer :user_id

      t.timestamps
    end
    add_index :shout_likes, :shout_id
    add_index :shout_likes, :user_id
    add_index :shout_likes, [:shout_id, :user_id], unique: true
  end
end
