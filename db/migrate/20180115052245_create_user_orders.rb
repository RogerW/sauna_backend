class CreateUserOrders < ActiveRecord::Migration[5.0]
  def change
    create_view :user_orders
  end
end
