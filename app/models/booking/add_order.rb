class Booking::AddOrder < ActiveType::Object
  attribute :user_id, :integer
  attribute :start_date_time, :datetime
  attribute :duration, :integer
  attribute :sauna_id, :integer
  attribute :guest_num, :integer
  attribute :full_name, :string
  attribute :phone, :string

  belongs_to :user, class_name: 'User'
  belongs_to :sauna, class_name: 'Sauna'

  validates_presence_of :user_id, :sauna_id, :duration, :start_date_time

  validates_presence_of :full_name, :phone

  # validates :can_reserv?

  after_save :create_contacts
  after_save :create_reservation

  private

  def can_reserv?
    end_date_time = start_date_time + duration.hours

    unless Reservation.new(reserv_range: start_date_time...end_date_time,
                           user_id: user_id,
                           guests_num: guest_num,
                           sauna_id: sauna_id,
                           contact_id: 1).valid?
      errors.add(:reserv, 'На это время нельза забронировать')
    end
  end

  def create_contacts
    if User.find(user_id).saunas.find(sauna_id)
      last_name, first_name, middle_name = full_name.split(/\s+/)

      last_name ||= ''
      first_name ||= ''
      middle_name ||= ''

      @contact = Sauna.find(sauna_id).contacts.find_or_create_by(
        first_name: first_name,
        last_name: last_name,
        middle_name: middle_name,
        phone: phone
      )
    else
      @contact = user.contact
      unless Sauna.find(sauna_id).contacts.exists?(id: @contact.id)
        Sauna.find(sauna_id).contacts << @contact
      end
    end

    # Sauna.find(sauna_id).contacts << @contact unless Sauna.find(sauna_id).contacts.exists?(id: @contact.id)
  end

  def create_reservation
    # puts start_date_time
    # start_date_time = DateTime.strptime(
    #   params[:booking][:start_date_time].gsub(/\s+/, '+'), '%Y-%m-%dT%H:%M:%S'
    # )
    end_date_time = start_date_time + duration.hours

    Reservation.create(reserv_range: start_date_time...end_date_time,
                       user_id: user_id, guests_num: guest_num,
                       sauna_id: sauna_id, contact_id: @contact.id,
                       aasm_state: 'created_by_admin')
  end
end
