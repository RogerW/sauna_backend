class BillingsController < ApplicationController
  include Spa

  private

  def set_model
    @model = if params[:sauna_id].present?
               Sauna.find(params[:sauna_id]).billings
             else
               Billings
             end
  end

  # Only allow a trusted parameter "white list" through.
  def resource_params
    params.require(:billing).permit(:sauna_id, :day_type, :start_time, :end_time, :cost)
  end
end
