class CreatePromos < ActiveRecord::Migration[5.1]
  def change
    create_table :promos do |t|
      t.string :title
      t.tsrange :active_range
      t.belongs_to :sauna, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :status
      t.string :desc

      t.timestamps
    end
  end
end
