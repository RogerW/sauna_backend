class UpdateBookingsToVersion6 < ActiveRecord::Migration[5.0]
  def change
    update_view :bookings, version: 6, revert_to_version: 5
  end
end
