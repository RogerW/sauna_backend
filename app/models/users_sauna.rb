class UsersSauna < ApplicationRecord
  # include Her::Model

  belongs_to :user
  belongs_to :sauna

  def user
    User.find user_id
  end

  def user=(u)
    self.user_id = u.id
  end

end
