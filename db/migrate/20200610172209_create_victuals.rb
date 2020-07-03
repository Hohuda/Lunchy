class CreateVictuals < ActiveRecord::Migration[6.0]
  def change
    create_table :victuals do |t|
      t.string :name, null: false
      t.decimal :price, null: false
      t.timestamps
    end
    add_index :victuals, [:name, :price], unique: true
  end
end
