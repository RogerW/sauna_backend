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

  def resource_params
    start_datetime = Time.strptime(params[:booking][:start_date_time].gsub(/\s+/, '+'), '%Y-%m-%dT%H:%M:%S%z')
    end_datetime = start_datetime + params[:booking][:duration].to_i.hours

    params.require(:booking)
          .permit(:guests_num, :sauna_id)
          .merge(user_id: AppUser.current_user.id)
          .merge(reserv_range: start_datetime...end_datetime)
  end
end
