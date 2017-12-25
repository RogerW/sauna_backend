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
      :name, :address_id, :logotype,
      sauna_descriptions_attributes: [:description],
      billings_attributes: %i[day_type start_time end_time]
    )
  end
end
