class CreateSaunaGalleries < ActiveRecord::Migration[5.1]
  def change
    create_table :sauna_galleries do |t|
      t.belongs_to :sauna, foreign_key: true
      t.string :photo

      t.timestamps
    end
  end
end
