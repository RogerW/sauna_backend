class DropCityColumnFromSaunas < ActiveRecord::Migration[5.1]
  def change
    create_table :city_areas do |t|
      t.string :name, null: false
      t.belongs_to :city, foreign_key: true
    end
  end
end
