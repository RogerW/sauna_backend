class PromoPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve; end
  end

  def initialize(user, promo)
    @user = user
    @promo = promo
  end

  def create?
    @user.admin? && UsersSauna.where(user_id: user.id).exists?
  end

  def update?
    @user.admin? && UsersSauna.where(user_id: user.id).exists?
  end

  def destroy?
    @user.admin? && UsersSauna.where(user_id: user.id).exists?
  end
end
