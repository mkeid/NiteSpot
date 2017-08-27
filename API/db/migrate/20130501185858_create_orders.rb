class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string 'comment'
      t.float 'ns_bill'
      t.time 'order_time'
      t.float 'service_bill'
      t.integer 'service_id'
      t.timestamps
    end
  end
end
