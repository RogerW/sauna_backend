class DropStatusColumnFromReservations < ActiveRecord::Migration[5.1]
  def change
    remove_column :reservations, :status
  end
end
