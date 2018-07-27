class Booking::AddOrdersController < ApplicationController
  include Spa

  private

  def set_model
    @model = Booking::AddOrder
  end

  def resource_params
    params.require(:booking_add_order)
          .permit(:duration, :full_name, :phone)
          .merge(user_id: AppUser.current_user.id)
          .merge(sauna_id: params[:sauna_id])
          .merge(start_date_time: Time.strptime(
            params[:booking_add_order][:start_date_time].gsub(/\s+/, '+'),
            '%Y-%m-%dT%H:%M'
          ))
  end
end
