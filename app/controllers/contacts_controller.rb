class ContactsController < ApplicationController
  include Spa

  # before_action :set_resource, only: %i[show update destroy]

  # GET /contacts
  def index
    authorize @model, :index?

    # @collection = @model.all

    render json: Oj.dump(
      collection: @model.all
    )
  end

  def show
    # @resource = @model.take(params[:id])
    authorize @model, :show?
    render json: Oj.dump(
      collection: @resource,
      single: true
    )
  end

  private

  def set_model
    @model = if params[:sauna_id].present?
               Sauna.find(params[:sauna_id]).contacts
             else
               Contact
             end
  end

  def resource_params
    params.require(:contacts)
          .permit(:last_name, :first_name, :middle_name, :phone)
  end

end
