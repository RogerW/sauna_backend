class BillingPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve; end
  end

  def initialize(user, sauna)
    @user = user
    @sauna = sauna
  end

  def create?
    UsersSauna.where(user_id: user.id).exists?
  end

  def update?
    UsersSauna.where(user_id: user.id).exists?
  end

  def destroy?
    UsersSauna.where(user_id: user.id).exists?
  end
end
