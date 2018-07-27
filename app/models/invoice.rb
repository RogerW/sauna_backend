class Invoice < ApplicationRecord
  include AASM
  belongs_to :sauna
  belongs_to :user
  has_and_belongs_to_many :reservations

  # enum status: %i[created paid cash canceled_by_user canceled_by_admin canceled_by_system]
  enum inv_type: %i[prepaid postpaid]

  aasm do
    state :created, initial: true
    state :prepaid_processing
    state :prepaid_in_system
    state :paid_in_cash
    state :paid_by_card
    state :paid
    state :canceled_by_user
    state :canceled_by_admin
    state :canceled_by_system

    event :pay do
      transitions from: [:prepaid_processing], to: :paid
    end

    event :prepaid_process do
      transitions from: [:created], to: :prepaid_processing
    end

    event :cashing do
      transitions from: [:created], to: :paid_in_cash, guard: :can_paid_in_cash?
    end

    event :cancel_by_user do
      transitions from: [:created], to: :canceled_by_user
    end

    event :cancel_by_admin do
      transitions from: [:created], to: :canceled_by_admin
    end

    event :cancel_by_system do
      transitions from: [:created], to: :canceled_by_system
    end
  end

  def can_paid_in_cash?
    postpaid?
  end
end
