class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.tstzrange :reserv_range
      t.integer :state
      t.belongs_to :sauna, foreign_key: true
      t.bigint :user_id, null: false
      t.belongs_to :contact, foreign_key: true
      t.integer :guests_num

      t.timestamps
    end
  end
end
