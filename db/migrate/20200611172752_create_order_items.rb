class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :menu_item
      t.timestamps
    end
    add_index :order_items, [:menu_id, :order_id], unique: true
  end
end
