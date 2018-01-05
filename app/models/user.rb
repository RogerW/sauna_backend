class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :set_default_role, if: :new_record?

  enum role: %i[user admin cashier root]

  has_many :saunas
  has_many :reservations
  has_one  :contact, as: :contactable
  has_many :invoices
  has_many :users_saunas
  has_and_belongs_to_many :saunas, join_table: 'users_saunas', foreign_key: 'user_id'

  def public_fields
    attributes.slice('email', 'created_at', 'role')
  end

  private

  def set_default_role
    self.role ||= :user
  end
end

# class User
#   include Her::Model

#   def arel_table # :nodoc:
#     @arel_table ||= Arel::Table.new(table_name, arel_engine)
#   end

#   # has_many :saunas, through: :users_saunas
# end

# class User < Spyke::Base

#   has_many :saunas
#   has_many :reservations
#   has_one  :contact, as: :contactable
#   has_many :invoices
#   has_many :users_saunas

#   # has_many :saunas, through: :users_saunas
# end
