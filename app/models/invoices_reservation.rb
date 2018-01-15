class InvoicesReservation < ApplicationRecord
  belongs_to :invoice
  belongs_to :reservation
end
