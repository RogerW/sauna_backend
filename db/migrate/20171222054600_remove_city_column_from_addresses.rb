class RemoveCityColumnFromAddresses < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :city_id, :bigint
    add_reference :addresses, :city_area, index: true
  end
end
