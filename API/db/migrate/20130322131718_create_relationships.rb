class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.boolean :accepted, :default => false
      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
  def down
    remove_index :relationships, [:follower_id, :followed_id], unique: true
    remove_index :relationships, :followed_id
    remove_index :relationships, :follower_id
    drop_table :relationships
  end
end
