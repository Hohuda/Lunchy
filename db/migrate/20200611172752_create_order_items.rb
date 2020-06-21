class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :menu_item
      t.integer :quantity, default: 1
      t.timestamps
    end
    add_index :order_items, [:order_id, :menu_item_id], unique: true
  end
end
