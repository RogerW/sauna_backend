class ReservationAutoStartWorker
  include Sidekiq::Worker

  def perform(reserv_id)
    reserv = Reservation.find_by(id: reserv_id)

    if reserv.may_execute? &&
       ActiveSupport::TimeZone.new('Asia/Yekaterinburg')
                              .local_to_utc(reserv.reserv_range.first) <=
       Time.now

      reserv.execute!
    end

    # reserv.complete! if reserv.may_complete?
  end
end
