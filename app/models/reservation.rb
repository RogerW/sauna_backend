class Reservation < ApplicationRecord
  belongs_to :sauna
  belongs_to :user
  belongs_to :contact
  has_and_belongs_to_many :invoices

  validate :check_intersection_range
  validate :start_less_end

  after_create :create_invoices

  after_initialize :set_status, if: :new_record?
  after_save :create_sheduler

  enum status: %i[created_by_user created_by_admin created_by_system appoved execute done cancel_by_user cancel_by_admin cancel_by_system]

  scope :intersection_range, lambda { |reserv_range, id, sauna_id|
    where('reserv_range && tstzrange(:start, :end)', start: reserv_range.begin, end: reserv_range.end)
      .where(sauna_id: sauna_id)
      .where.not(id: id)
      .where(status: %i[created_by_user created_by_admin created_by_system appoved execute done])
  }

  # def intersection_range
  #   reserv_table = Arel::Table.new(:reservations)

  #   self.class.where('reserv_range && tstzrange(:start, :end)', start: reserv_range.begin, end: reserv_range.end)
  #       .where(sauna_id: sauna_id)
  #       .where(reserv_table[:id].not_eq(id))
  #       .where(status: %i[created_by_user created_by_admin created_by_system appoved execute done])
  # end

  def get_cost
    time_range = []
    if reserv_range.end.day - reserv_range.begin.day > 1
      time_range.append(
        (reserv_range.begin.hour * 60 + reserv_range.begin.min) / 60.0...24.0
      )

      time_range.append(0.0...(reserv_range.end.hour * 60 + reserv_range.end.min) / 60.0)
    # self.invoices
    else
      time_range.append((reserv_range.begin.hour * 60 + reserv_range.begin.min) / 60.0...(reserv_range.end.hour * 60 + reserv_range.end.min) / 60.0)
    end

    cost_sum = 0

    time_range.each do |tr|
      billings = Billing
                 .select(
                   "numrange(start_time, end_time) * numrange(#{tr.begin},#{tr.end}) as period, cost_cents, cost_currency"
                 )
                 .where(
                   'numrange(start_time, end_time) && numrange(:start, :end)',
                   start: tr.begin,
                   end: tr.end
                 )

      # puts  billings.to_sql

      billings.each do |bill|
        cost_sum += (bill.period.end - bill.period.begin) * bill.cost_cents
      end
    end

    cost_sum
  end

  private

  def set_status
    self.status ||= if user.admin?
                      :created_by_admin
                    else
                      :created_by_user
                    end
  end

  def start_less_end
    errors.add(:reserv_range, 'В этом промежутке времени нельзя забронировать.') if reserv_range.begin >= reserv_range.end
  end

  def check_intersection_range
    # puts self.class.where("reserv_range && tstzrange(:start, :end)", start: reserv_range.begin, end: reserv_range.end)
    # puts "exist!!!! #{intersection_range.exists?}"
    errors.add(:reserv_range, 'Время уже занято.') if self.class.intersection_range(reserv_range, id, sauna_id).exists?
  end

  def create_invoices
    cost_sum = get_cost

    if user.admin?
      invoices.create(sauna: sauna, user_id: user_id, inv_type: 1, state: 0, result_cents: cost_sum)
    else
      invoices.create(sauna: sauna, user_id: user_id, inv_type: 0, state: 0, result_cents: cost_sum / 10)
      invoices.create(sauna: sauna, user_id: user_id, inv_type: 1, state: 0, result_cents: cost_sum - cost_sum / 10)
    end
  end

  def create_sheduler
    if (created_by_admin? || created_by_user?) && (saved_change_to_reserv_range? || new_record?)
      puts 'Sheduled'
      ReservationAutoStartWorker.perform_at(reserv_range.first, id)
    end
  end
end
