class AddSedeToUsuarios < ActiveRecord::Migration[5.1]
  def change
    add_column :usuarios, :sede, :integer, default: 1
  end
end
