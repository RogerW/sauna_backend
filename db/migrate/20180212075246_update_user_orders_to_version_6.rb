class UpdateUserOrdersToVersion6 < ActiveRecord::Migration[5.0]
  def change
    update_view :user_orders, version: 6, revert_to_version: 5
    update_view :bookings, version: 5, revert_to_version: 4
  end
end
