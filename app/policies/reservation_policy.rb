class ReservationPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve
      if user && user.admin?
        # puts user
        # puts UsersSauna.where(user_id: user.id)
        UsersSauna.where(user_id: user.id).first.sauna.reservations # ToDo: Надо это убрать как-нибудь
      elsif user
        user.reservations
      else
        scope.select(
          "to_char(lower(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS start_date_time",
          "to_char(upper(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS end_date_time"
        )
      end
    end
  end

  def initialize(user, reservation)
    @user = user
    @reservation = reservation
  end

  def create?
    @user.user? || @user.admin?
  end

  def update?
    @user.admin? || (@reservation.user_id == @user.id && @reservation.created_by_user?)
  end

  def destroy?
    @user.admin? || @user.id == @reservation.user_id
  end
end
