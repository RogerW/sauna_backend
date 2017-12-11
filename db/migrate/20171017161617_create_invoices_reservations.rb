class CreateInvoicesReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices_reservations do |t|
      t.belongs_to :invoice, foreign_key: true
      t.belongs_to :reservation, foreign_key: true
    end
  end
end
