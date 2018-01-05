class DropTableCity < ActiveRecord::Migration[5.1]
  def change
    execute "DROP TABLE IF EXISTS cities CASCADE"
    execute "DROP TABLE IF EXISTS addresses CASCADE"
    execute "DROP TABLE IF EXISTS city_areas CASCADE"
    execute "DROP TABLE IF EXISTS countries CASCADE"
    execute "DROP TABLE IF EXISTS cities CASCADE"
  end
end
