class Invoice < ApplicationRecord
  belongs_to :sauna
  belongs_to :user
  has_and_belongs_to_many :reservations
  has_and_belongs_to_many :user_orders, join_table: "invoices_reservations", foreign_key: "reservation_id" 

  enum status: %i[created paid cash canceled_by_user canceled_by_admin canceled_by_system]
  enum inv_type: %i[prepaid postpaid]

end
