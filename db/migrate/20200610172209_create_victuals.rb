class CreateVictuals < ActiveRecord::Migration[6.0]
  def change
    create_table :victuals do |t|
      t.string :name, null: false
      t.decimal :price
      t.timestamps
    end
    add_index :victuals, [:name, :victual_id], unique: true
  end
end
