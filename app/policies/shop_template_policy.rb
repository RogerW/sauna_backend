class ShopTemplatePolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve; end
  end

  def initialize(user, order_template)
    @user = user
    @order_template = order_template
  end

  def index?
    puts "#{@user} @user"
    @user.admin?
  end
end
