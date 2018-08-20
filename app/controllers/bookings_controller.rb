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
    @model = Booking.where(user_id: AppUser.current_user.id)

    @model = @model.where(sauna_id: params[:sauna_id]) if params[:sauna_id]

    if params[:start_datetime] && params[:end_datetime]
      @model = @model.where(
        start_date_time: Time.at(params[:start_datetime].to_i)..DateTime::Infinity.new
      )
    end

    if params[:end_datetime]
      @model = @model.where(
        start_date_time: Time.at(0)..Time.at(params[:end_datetime].to_i)
      )
    end
  end
end
