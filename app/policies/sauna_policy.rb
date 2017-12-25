class SaunaPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      super(user, scope)
    end

    def resolve
    end
  end

  def initialize(user, sauna)
    @user = user
    @sauna = sauna
  end

  def get_contacts?
    UsersSauna.where(user_id: user.id).exists?
  end

  def create?
    @user.admin?
  end

  def update?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end
end
