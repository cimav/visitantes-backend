class ChangeNotaToText < ActiveRecord::Migration[5.0]
  def change
    change_column(:visitantes, :nota, :text)
    change_column(:visitas, :nota, :text)
  end
end
