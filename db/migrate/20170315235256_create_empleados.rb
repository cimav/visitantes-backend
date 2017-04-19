class CreateEmpleados < ActiveRecord::Migration[5.0]
  def change

      create_table :empleados, { id: false } do |t|
        t.integer :id
        t.string :nombre
      end

      execute "ALTER TABLE empleados ADD PRIMARY KEY (id);"

  end
end
