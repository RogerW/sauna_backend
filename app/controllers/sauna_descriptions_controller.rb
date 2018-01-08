class SaunaDescriptionsController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    collection = @model

    render json: Oj.dump(
      collection: collection
    )
  end

  private

  def set_model
    if params[:id]
      @model = Sauna.find(params[:id]).sauna_description
    else
      @model = Sauna.find(params[:sauna_id]).sauna_description
    end
  end

  def resource_params
    params.require(:sauna_description).permit(:sauna_id, :description, :services)
  end
end
