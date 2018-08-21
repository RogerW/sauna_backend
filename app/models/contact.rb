class Contact < ApplicationRecord
  # belongs_to :user

  belongs_to :contactable, polymorphic: true

  before_save :change_confirm_code

  private

  def change_confirm_code
    return unless phone_changed? || self.confirm_code.nil?

    self.confirm_code = (0...4).map { (1..9).to_a[rand(9)] }.join
    self.confirmed_at = nil
    self.confirm_send_at = nil
    self.code_retry_count = 0
    self.code_send_count = 0
  end
end
