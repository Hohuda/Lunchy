class CreateMenuItems < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_items do |t|
      t.references :menu
      t.references :victual
      t.timestamps
    end
    add_index :menu_items, [:menu_id, :victual_id], unique: true
  end
end
