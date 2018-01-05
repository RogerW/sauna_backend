class AddCityUuidAndStreetUuidColumnsToSaunas < ActiveRecord::Migration[5.1]
  def change
    add_column :saunas, :city_uuid, :uuid
    add_column :saunas, :street_uuid, :uuid
    add_column :saunas, :full_address, :string
  end
end
