class AddHouseAndLatAndLonAndNoteColumnsToSaunas < ActiveRecord::Migration[5.1]
  def change
    add_column :saunas, :house, :string
    add_column :saunas, :lat, :decimal, precision: 9, scale: 6
    add_column :saunas, :lon, :decimal, precision: 9, scale: 6
    add_column :saunas, :note, :string
  end
end
