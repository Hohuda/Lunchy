class CreateCategoryItems < ActiveRecord::Migration[6.0]
  def change
    create_table :category_items do |t|
      t.references :victual
      t.references :category
      t.timestamps
    end
    add_index :category_items, [:victual_id, :category_id], unique: true
  end
end
