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
      else
        user.reservations
        # scope.select(:id, :reserv_range)
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
