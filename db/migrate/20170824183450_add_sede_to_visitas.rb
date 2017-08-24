class AddSedeToVisitas < ActiveRecord::Migration[5.0]
  def change
    add_column :visitas, :sede, :integer
  end
end
