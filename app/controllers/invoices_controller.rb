class InvoicesController < ApplicationController
  include Spa
  before_action :set_resource, only: %i[show update destroy pay_in_cash]

  def index
    collection =
      InvoicePolicy::Scopee.new(AppUser.current_user, @model).resolve

    render json: Oj.dump(collection: collection)
  end

  def pay_in_cash
    authorize @resource, :pay_in_cash?

    @resource.cashing!

    render json: Oj.dump(collection: @resource)
  end

  private

  def set_model
    @model = if params[:reservation_id].present?
               Reservation.find(params[:reservation_id]).invoices
             else
               Invoice
             end
  end
end
