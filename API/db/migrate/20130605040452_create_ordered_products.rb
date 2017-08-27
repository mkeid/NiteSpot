class CreateOrderedProducts < ActiveRecord::Migration
  def change
    create_table :ordered_products do |t|
      t.integer 'order_id'
      t.integer 'product_id'
      t.timestamps
    end
  end
end
