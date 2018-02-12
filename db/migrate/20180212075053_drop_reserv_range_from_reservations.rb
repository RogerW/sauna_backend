class DropReservRangeFromReservations < ActiveRecord::Migration[5.1]
  def change
    update_view :user_orders, version: 5, revert_to_version: 4
    update_view :bookings, version: 4, revert_to_version: 3
    remove_column :reservations, :reserv_range, :tstzrange
    add_column :reservations, :reserv_range, :tsrange
  end
end
