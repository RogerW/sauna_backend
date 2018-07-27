class InvoicePolicy < ApplicationPolicy
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

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
  end

  def create?
    @user.admin?
  end

  def update?
    @user.admin? && Sauna.find(@invoice.sauna_id)
                         .users.where(id: @user.id).exists?
  end

  def destroy?
    @user.admin?
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
