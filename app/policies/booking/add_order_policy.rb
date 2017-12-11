class Booking::AddOrderPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      super(user, scope)
    end

    def resolve
      scope.all
    end
  end

  def create?
    @user.user? or user.saunas.exists?(id: scope.id)
  end

end
