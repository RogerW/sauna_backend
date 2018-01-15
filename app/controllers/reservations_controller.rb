class ReservationsController < ApplicationController
  include Spa
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    collection = ReservationPolicy::Scopee.new(AppUser.current_user, @model).resolve
    # collection = collection.select(:id, :reserv_range) if AppUser.current_user.nil? || AppUser.current_user.role != :admin

    render json: Oj.dump(collection: collection)
  end

  def create
    authorize @model

    sauna = Sauna.find(params[:sauna_list_id])
    contact = AppUser.current_user.contact
    sauna_contact = sauna.contacts
                         .find_or_create_by(
                           first_name: contact.first_name,
                           last_name: contact.last_name,
                           middle_name: contact.middle_name,
                           phone: contact.phone
                         )

    @resource = @model.new(resource_params.merge(contact_id: sauna_contact.id))

    if @resource.save
      @collection = @model.where(id: @resource.id)
      # ReservationCancelByNonPaymentWorker.perform_in(20.minutes, @collection) if AppUser.current_user.user?

      render json: { msg: 'Сауна забронирована.' }
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  def destroy
    resource = @model.find(params[:id])

    authorize resource
    if AppUser.current_user.admin?
      if resource.may_cancel_by_admin?
        esource.cancel_by_admin!
        render json: Oj.dump(
          msg: 'Заказ отменен'
        )
      else
        render json: Oj.dump(
          msg: 'Невозможно отменить заказ!'
        )
      end
    else
      if resource.may_cancel_by_user?
        resource.cancel_by_user!
        render json: Oj.dump(
          msg: 'Заказ отменен'
        )
      else
        render json: Oj.dump(
          msg: 'Невозможно отменить заказ!'
        )
      end
    end
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
  end
end
