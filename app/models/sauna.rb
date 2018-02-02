class Sauna < ApplicationRecord
  has_attached_file :logotype,
                    styles: {
                      large:  '1200x900#',
                      medium: '400x300#',
                      thumb: ['40x30#', :webp]
                    },
                    default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :logotype, content_type: /\Aimage\/.*\z/

  has_many :reservations
  has_many :billings
  has_many :sauna_galleries
  has_one :sauna_description

  accepts_nested_attributes_for :billings, reject_if: proc { |attributes| attributes[:start_time, :end_time, :cost].blank? }, allow_destroy: true
  accepts_nested_attributes_for :sauna_description, reject_if: proc { |attributes| attributes[:description].blank? }, allow_destroy: true

  has_many :contacts, as: :contactable

  has_and_belongs_to_many :users, join_table: 'users_saunas', foreign_key: 'sauna_id'
end
