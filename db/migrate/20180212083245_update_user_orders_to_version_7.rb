class UpdateUserOrdersToVersion7 < ActiveRecord::Migration[5.0]
  def change
    update_view :user_orders, version: 7, revert_to_version: 6
  end
end
