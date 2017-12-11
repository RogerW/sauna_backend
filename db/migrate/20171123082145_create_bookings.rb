class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_view :bookings
  end
end
