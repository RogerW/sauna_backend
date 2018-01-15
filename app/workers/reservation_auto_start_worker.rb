class ReservationAutoStartWorker
  include Sidekiq::Worker

  def perform(reserv_id)
    reserv = Reservation.find_by(id: reserv_id)

    case reserv.aasm_state
    when Reservation::STATE_CREATED_BY_USER
      reserv.approve!
    when Reservation::STATE_CREATED_BY_ADMIN
      reserv.execute!
    when Reservation::STATE_CREATED_BY_SYSTEM
      reserv.execute!
    when Reservation::STATE_APPROVED
      reserv.execute!
    when Reservation::STATE_DONE
      reserv.complete!
    end

    # reserv.execute! if (reserv.created_by_user? || reserv.created_by_admin?) && reserv.reserv_range.first < Time.now
  end
end
