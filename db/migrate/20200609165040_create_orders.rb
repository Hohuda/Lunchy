class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :menu
      t.decimal :total_cost, null: false, default: 0
      t.boolean :editable, null: false, default: true
      t.timestamps
    end
    # add_index :orders, [:order_id, :user_id], unique: true
    add_index :orders, :created_at
  end
end
