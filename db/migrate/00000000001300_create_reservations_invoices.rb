class CreateReservationsInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations_invoices, id: false do |t|
      t.belongs_to :invoice, foreign_key: true
      t.belongs_to :reservation, foreign_key: true
    end
  end
end
