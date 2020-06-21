class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :menu
      t.decimal :total_cost, null: false, default: 0
      t.timestamps
    end
    # add_index :orders, [:order_id, :user_id], unique: true
    add_index :orders, [:user_id, :created_at]
  end
end
