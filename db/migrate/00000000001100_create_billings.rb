class CreateBillings < ActiveRecord::Migration[5.1]
  def change
    create_table :billings do |t|
      t.belongs_to :sauna, foreign_key: true
      t.integer :day_type
      t.integer :start_time
      t.integer :end_time
      t.monetize :cost

      t.timestamps
    end
  end
end
