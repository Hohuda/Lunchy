class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    add_index :categories, [:category_id, :name], unique: true
  end
end
