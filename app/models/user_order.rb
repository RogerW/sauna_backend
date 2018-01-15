class UserOrder < ApplicationRecord

  enum status: %i[created_by_user created_by_admin created_by_system appoved execute done cancel_by_user cancel_by_admin cancel_by_system]

  belongs_to :user, foreign_key: "user_id"
  has_and_belongs_to_many :invoices, join_table: "invoices_reservations", foreign_key: "invoice_id", association_foreign_key: 'reservation_id', class_name: 'Reservation'
  belongs_to :sauna, foreign_key: "sauna_id"
end 
