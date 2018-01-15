class UserOrdersController < ApplicationController
  before_action :set_model

  def index
    collection = @model.all
    collection_json = collection.as_json

    result = []

    collection.each_with_index do |e, i|
      sauna = e.sauna
      invoices_ids = InvoicesReservation.where(reservation_id: e.id).pluck(:invoice_id)
      invoices = Invoice.where(id: invoices_ids).all
      result.push collection_json[i].merge(logotype_image: sauna.logotype.url(:large),
                                           logotype_medium: sauna.logotype.url(:medium),
                                           logotype_thumb: sauna.logotype.url(:thumb),
                                           invoices: invoices)
    end

    render json: Oj.dump(
      collection: result
    )
  end

  private 

  def set_model
    @model = UserOrder.where(user_id: AppUser.current_user.id)
  end
end