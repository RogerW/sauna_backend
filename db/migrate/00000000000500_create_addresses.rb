class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.belongs_to :city, foreign_key: true
      t.string :house
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lon, precision: 9, scale: 6
      t.string :notes

      t.timestamps
    end
  end
end
