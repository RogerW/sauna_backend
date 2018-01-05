class SaunasController < ApplicationController
  include Spa

  before_action :set_sauna, only: %i[show update destroy get_contacts]

  def get_contacts
    @collection = @sauna.contacts.all

    authorize @sauna, :get_contacts?

    render json: Oj.dump(
      collection: @collection
    )
  end

  def create
    @resource = @model.new resource_params

    authorize @resource

    # street = Sauna.find_by_sql ['SELECT fstf_AddressObjects_SearchByName(?, NULL, ?) as addr', params[:street], params[:city]]

    # full_address = Sauna.find_by_sql(["select fsfn_AddressObjects_TreeActualName(?) as full_address", street.addr.match(/([\d\w\-]+)/)[0]]).first

    r_params = resource_params
      # .merge(full_address: full_address.full_address)
      # .merge(street_uuid: street.addr.match(/([\d\w\-]+)/)[0])

    @resource = @model.new r_params

    if @resource.save
      @collection = @model.where(id: @resource.id)

      render json: Oj.dump(collection: @collection)
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end

  end

  private

  def set_model
    @model = Sauna
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sauna
    @sauna = Sauna.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def resource_params
    params.require(:sauna).permit(
      :name, :logotype,
      sauna_descriptions_attributes: [:description],
      billings_attributes: %i[day_type start_time end_time]
    )
  end
end
