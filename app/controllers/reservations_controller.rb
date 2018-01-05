class ReservationsController < ApplicationController
  include Spa
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    collection = ReservationPolicy::Scopee.new(AppUser.current_user, @model).resolve
    # collection = collection.select(:id, :reserv_range) if AppUser.current_user.nil? || AppUser.current_user.role != :admin

    render json: Oj.dump(collection)
  end

  def create
    authorize @model

    @resource = @model.new(resource_params)

    if @resource.save
      @collection = @model.where(id: @resource.id)
      # ReservationCancelByNonPaymentWorker.perform_in(20.minutes, @collection) if AppUser.current_user.user?

      render json: Oj.dump(@collection)
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  def destroy
    resource = @model.find(params[:id])

    authorize resource
    if AppUser.current_user.admin?
      resource.cancel_by_admin!
    else
      resource.cancel_by_user!
    end

    render json: Oj.dump(
      msg: 'Заказ отменен'
    )
  end

  private

  def set_model
    @model = if params[:sauna_list_id].present?
               Sauna.find(params[:sauna_list_id]).reservations
             else
               Reservation
             end
  end

  def resource_params
    start_date_time = Time.strptime(params[:reservation][:start_date_time].gsub(/\s+/, '+'), '%Y-%m-%dT%H:%M:%S%z')
    end_date_time = start_date_time + params[:reservation][:duration].to_i.hours

    params.require(:reservation)
          .permit(:guests_num, :sauna_id)
          .merge(reserv_range: start_date_time...end_date_time)
          .merge(user_id: AppUser.current_user.id)
          .merge(contact_id: AppUser.current_user.contact)
  end
end
