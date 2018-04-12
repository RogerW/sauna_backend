class AddImageColumnToPromos < ActiveRecord::Migration[5.1]
  def change
    add_attachment :promos, :image
  end
end
