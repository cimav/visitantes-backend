class RecreateVisitas < ActiveRecord::Migration[5.0]
  def change
    create_table :visitas do |t|
      t.timestamp :entrada
      t.timestamp :salida
      t.string :nota

      t.references :visitante
      t.references :empleado

      t.timestamps
    end


  end
end
