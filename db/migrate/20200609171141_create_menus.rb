class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.string :name, default: "noname_menu"
      t.timestamps
    end
  end
end
