class CreateOrderLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :order_logs do |t|
      t.belongs_to :reservation, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :state_from
      t.string :state_to
      t.string :note
      t.string :event

      t.timestamps
    end
  end
end
