class AddTipoToVisitantes < ActiveRecord::Migration[5.0]
  def change
    add_column :visitantes, :tipo, :integer
  end
end
