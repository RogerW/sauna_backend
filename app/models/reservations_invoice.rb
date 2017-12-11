class ReservationsInvoice < ApplicationRecord
  belongs_to :invoice
  belongs_to :reservation
end
