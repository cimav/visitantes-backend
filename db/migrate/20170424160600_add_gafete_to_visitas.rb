class AddGafeteToVisitas < ActiveRecord::Migration[5.0]
  def change
    add_column :visitas, :gafete, :string
  end
end
