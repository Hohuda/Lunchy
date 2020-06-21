class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.string :name, default: "noname_menu"
      t.timestamps
    end
    add_index :menus, [:created_at]
  end
end
