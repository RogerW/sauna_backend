class Sauna < ApplicationRecord
  has_attached_file :logotype,
                    styles: {
                      large: '1200x900>',
                      medium: '400x300>',
                      thumb: ['40x30>', :webp]
                    },
                    default_url: '/api/v1/assets/:style/missing.png'
  validates_attachment_content_type :logotype, content_type: /\Aimage\/.*\z/

  belongs_to :city
  belongs_to :address

  has_many :reservations
  has_many :billings

  has_many :sauna_descriptions

  has_many :contacts, as: :contactable

  has_and_belongs_to_many :users, join_table: 'users_saunas', foreign_key: 'user_id'
end
