class Billing < ApplicationRecord
  belongs_to :sauna

  scope :select_max_and_min, -> { select("MAX(billings.cost_cents) AS max_cost_cents, MIN(billings.cost_cents) AS min_cost_cents") }

  monetize :cost_cents
end
