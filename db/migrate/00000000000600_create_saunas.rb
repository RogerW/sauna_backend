class CreateSaunas < ActiveRecord::Migration[5.1]
  def change
    create_table :saunas do |t|
      t.string :name
      t.belongs_to :city, foreign_key: true
      t.belongs_to :address, foreign_key: true
      t.string :logo
      t.decimal :rating, precision: 2, scale: 1

      t.timestamps
    end
  end
end
