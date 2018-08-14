class ShotMessage < ApplicationRecord
  belongs_to :user

  include AASM
  
  aasm do
    state :created, initial: true
    state :pending
    state :processing
    state :sended
    state :delivered
    state :canceled

    event :pend do
      transitions from: [:created], to: :pending
    end

    event :process do
      transitions from: [:pending], to: :processing
    end

    event :send_sms do
      transitions from: [:processing], to: :sended
    end

    event :deliver do
      transitions from: [:sended], to: :delivered
    end

    event :cancel do
      transitions from: %i[created sended], to: :canceled
    end
  end

  after_create :shedule_send
  # after_initialize :set_status, if: :new_record?

  private

  # def set_status
  #   this.next_at = Time.now + 30.seconds
  # end

  def shedule_send
    SendSmsWorker.perform_in(1.seconds, id)
  end
end
