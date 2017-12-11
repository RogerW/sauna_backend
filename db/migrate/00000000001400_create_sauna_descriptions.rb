class CreateSaunaDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :sauna_descriptions do |t|
      t.belongs_to :sauna, foreign_key: true
      t.string :description
      t.jsonb :services

      t.timestamps
    end
  end
end
