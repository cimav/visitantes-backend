class ChangeEmpleadoToPersonaInVisitas < ActiveRecord::Migration[5.0]
  def change
    rename_column :visitas, :empleado_id, :persona_id
  end
end
