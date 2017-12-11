class SaunaDescriptionsController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show]

  private

  def set_model
    @model = Sauna.take(params[:id]).sauna_descriptions
  end

  def resource_params
    params.require(:sauna_description).permit(:sauna_id, :description, :services)
  end
end
