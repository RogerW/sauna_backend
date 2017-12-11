class ReservationCancelByNonPaymentWorker
  include Sidekiq::Worker

  def perform(Reservation)
    Reservation.cancel_by_system! if Reservation.created_by_user?
  end
end
