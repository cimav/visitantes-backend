class AddEmpresaNotaToVisitante < ActiveRecord::Migration[5.0]
  def change
    add_column :visitantes, :empresa, :string
    add_column :visitantes, :nota, :string
    end
end
