class ContactPolicy < ApplicationPolicy
  class Scopee < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      super(user, scope)
    end

    def resolve
      if user && user.admin?
        sauna_ids = UsersSauna.where(user_id: user.id).all.pluck(:sauna_id)
        scope.where(sauna_id: sauna_ids)
      elsif user
        user.invoices
      end
    end
  end

  def initialize(user, contact)
    @user = user
    @contact = contact
  end

  def index?
    @user.admin? &&
      UsersSauna.where(
        sauna_id: @contact.pluck(:contactable_id), user_id: @user.id
      ).exists?
  end

  def create?
    @user.admin?
  end

  def show?
    @user && (UsersSauna.where(
      sauna_id: @contact.pluck(:contactable_id), user_id: @user.id
    ).exists? || @user.contact.id == @contact.id)
  end

  def update?
    @user && (UsersSauna.where(
      sauna_id: @contact.pluck(:contactable_id), user_id: @user.id
    ).exists? || @user.contact.id == @contact.id)
  end

  def destroy?
    @user && (UsersSauna.where(
      sauna_id: @contact.pluck(:contactable_id), user_id: @user.id
    ).exists? || @user.contact.id == @contact.id)
  end

  def pay_in_cash?
    # puts @user.admin?
    # puts Sauna.find(@invoice.sauna_id).users.where(id: @user.id).exists?
    # puts @invoice.may_cashing?
    # puts @invoice.postpaid?

    @user.admin? &&
      Sauna.find(@invoice.sauna_id)
           .users.where(id: @user.id).exists? &&
      @invoice.may_cashing?
  end
end
