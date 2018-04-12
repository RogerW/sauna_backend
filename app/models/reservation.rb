class Reservation < ApplicationRecord
  include AASM

  # enum status: %i[created_by_user created_by_admin created_by_system appoved execute done cancel_by_user cancel_by_admin cancel_by_system]

  aasm do
    state :created_by_user, initial: true
    state :created_by_admin
    state :created_by_system
    state :approved
    state :executing
    state :done
    state :canceled_by_user
    state :canceled_by_admin
    state :canceled_by_system

    event :create_by_admin do
      transitions from: [:created_by_user], to: :created_by_admin
    end

    event :create_by_system do
      transitions from: [:created_by_user], to: :created_by_system
    end

    event :approve do
      transitions from: %i[created_by_user created_by_admin created_by_system], to: :approved
    end

    event :execute do
      transitions from: %i[created_by_admin created_by_system], to: :executing
    end

    event :complete do
      transitions from: [:executing], to: :done
    end

    event :cancel_by_user do
      transitions from: %i[created_by_user created_by_system approved], to: :canceled_by_user
    end

    event :cancel_by_admin do
      transitions from: %i[created_by_admin created_by_system], to: :canceled_by_admin
    end

    event :cancel_by_system do
      transitions from: %i[created_by_system created_by_admin created_by_system], to: :canceled_by_system
    end
  end

  belongs_to :sauna
  belongs_to :user
  belongs_to :contact
  has_and_belongs_to_many :invoices

  validate :check_intersection_range
  validate :start_less_end

  after_create :create_invoices

  after_initialize :set_status, if: :new_record?
  after_save :create_sheduler 

  # enum status: %i[created_by_user created_by_admin created_by_system appoved execute done cancel_by_user cancel_by_admin cancel_by_system]

  scope :intersection_range, lambda { |reserv_range, id, sauna_id|
    where('reserv_range && tsrange(:start, :end)', start: reserv_range.begin, end: reserv_range.end)
      .where(sauna_id: sauna_id)
      .where.not(id: id)
      .where(aasm_state: %i[created_by_user created_by_admin created_by_system appoved executing done])
  }

  # def intersection_range
  #   reserv_table = Arel::Table.new(:reservations)

  #   self.class.where('reserv_range && tstzrange(:start, :end)', start: reserv_range.begin, end: reserv_range.end)
  #       .where(sauna_id: sauna_id)
  #       .where(reserv_table[:id].not_eq(id))
  #       .where(status: %i[created_by_user created_by_admin created_by_system appoved execute done])
  # end

  def get_cost
    puts self.sauna_id
    time_range = {}
    if reserv_range.end.day - reserv_range.begin.day == 1
      time_range[reserv_range.begin.wday] = (
        ((reserv_range.begin.hour * 60 + reserv_range.begin.min) / 60.0)...24.0
      )

      time_range[reserv_range.end.wday] = (0.0...(reserv_range.end.hour * 60 + reserv_range.end.min) / 60.0)
    else
      time_range[reserv_range.end.wday] = (((reserv_range.begin.hour * 60 + reserv_range.begin.min) / 60.0)...(reserv_range.end.hour * 60 + reserv_range.end.min) / 60.0)
    end

    cost_sum = 0

    time_range.each do |wday, tr|
      billings = Billing
                 .select(
                   "numrange(start_time, end_time) * numrange(#{tr.begin},#{tr.end}) as period, cost_cents, cost_currency"
                 )
                 .where(
                   'numrange(start_time, end_time) && numrange(:start, :end) AND day_type = :day_type AND sauna_id = :sauna_id',
                   start: tr.begin,
                   end: tr.end,
                   day_type: wday,
                   sauna_id: self.sauna_id
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
    self.aasm_state ||= if user.admin?
                          :created_by_admin
                        else
                          :created_by_user
                        end
    # if user.admin?
    #   create_by_admin!
    # else
    #   create_by_user!
    # end
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
    ReservationAutoStartWorker.perform_at(reserv_range.first, id)
  end
end
