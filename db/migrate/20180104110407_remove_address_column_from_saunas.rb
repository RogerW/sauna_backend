class RemoveAddressColumnFromSaunas < ActiveRecord::Migration[5.1]
  def change
    remove_column :saunas, :address_id
    # remove_index :saunas, :index_saunas_on_address_id
  end
end
