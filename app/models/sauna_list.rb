class SaunaList < ApplicationRecord
  has_attached_file :logotype
  # has_one :sauna, :foreign_key => :id
end