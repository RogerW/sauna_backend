class UpdateUserOrdersToVersion8 < ActiveRecord::Migration[5.0]
  def change
    update_view :user_orders, version: 8, revert_to_version: 7
  end
end
