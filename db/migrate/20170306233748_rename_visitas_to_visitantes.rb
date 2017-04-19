class RenameVisitasToVisitantes < ActiveRecord::Migration[5.0]
  def change
    rename_table :visitas, :visitantes
  end
end
