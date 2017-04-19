class AddAvatarToVisitas < ActiveRecord::Migration[5.0]
  def change
    add_column :visitantes, :avatar, :string
  end
end
