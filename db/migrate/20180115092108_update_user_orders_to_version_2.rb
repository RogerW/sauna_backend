class UpdateUserOrdersToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :user_orders, version: 2, revert_to_version: 1
  end
end
