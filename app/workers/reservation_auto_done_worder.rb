class ReservationAutoDoneWorker
  include Sidekiq::Worker

  def perform(reserv_id)
    reserv = Reservation.find_by(id: reserv_id)

    if reserv.may_complete? &&
       ActiveSupport::TimeZone.new('Asia/Yekaterinburg')
                              .local_to_utc(reserv.reserv_range.last) <=
       Time.now

      reserv.complete!
    end

    # reserv.complete! if reserv.may_complete?
  end
end
