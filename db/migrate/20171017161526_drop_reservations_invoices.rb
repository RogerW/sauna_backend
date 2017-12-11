class DropReservationsInvoices < ActiveRecord::Migration[5.1]
  def change
    drop_table :reservations_invoices
  end
end
