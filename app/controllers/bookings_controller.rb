class BookingsController < ApplicationController
  before_action :set_model

  def index
    collection = @model.all

    render json: Oj.dump(
      collection: collection
    )
  end

  def show
    @resource = Booking.where(id: params[:id]).first

    render json: Oj.dump(
      collection: @resource,
      single: true
    )
  end

  private

  def set_model
    sauna_id = params[:sauna_id] || 0

    @model = Booking.where(user_id: AppUser.current_user.id, sauna_id: sauna_id)
  end
end
