class AddAvatarToVictuals < ActiveRecord::Migration[6.0]
  def change
    add_column :victuals, :avatar, :string
  end
end
