class UsersContactPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve
      scope.select(%i[last_name first_name middle_name phone])
    end
  end

  def initialize(user, contact)
    @user = user
    @contact = contact
  end

end
