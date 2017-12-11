class ReservationAutoStartWorker
  include Sidekiq::Worker

  def perform(reserv_id)
    reserv = Reservation.find_by(id: reserv_id)

    reserv.execute! if (reserv.created_by_user? || reserv.created_by_admin?) && reserv.reserv_range.first < Time.now
  end
end
