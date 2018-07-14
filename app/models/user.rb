class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :email, email: true

  after_initialize :set_default_role, if: :new_record?

  enum role: %i[user admin cashier root]

  has_many :saunas
  has_many :reservations
  has_one  :contact, as: :contactable
  has_many :invoices
  has_many :users_saunas
  has_and_belongs_to_many :saunas, join_table: 'users_saunas', foreign_key: 'user_id'
  has_many :order_logs

  def public_fields
    attributes.slice('email', 'created_at', 'role')
  end

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
