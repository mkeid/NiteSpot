class CreateNetworkRequests < ActiveRecord::Migration
  def change
    create_table :network_requests do |t|
      t.integer 'school_id'
      t.integer 'user_id'
      t.timestamps
    end
  end
end
