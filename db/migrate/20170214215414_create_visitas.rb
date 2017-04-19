class CreateVisitas < ActiveRecord::Migration[5.0]
  def change
    create_table :visitantes do |t|
      t.string :rfc
      t.string :apellido
      t.string :nombre

      t.timestamps
    end
  end
end
