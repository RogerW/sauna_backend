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
    @model = if params[:id]
               SaunaDescription
             else
               Sauna.find(params[:sauna_id]).sauna_description
             end
  end

  def resource_params
    tags = {}

    params[:sauna_description].try(:fetch, :services, {}).keys.each do |k|
      tags[k] = []
      params[:sauna_description][:services][k].keys.each do |nk|
        tags[k].push nk
      end
    end

    params.require(:sauna_description).permit(:sauna_id, :description, services: tags)
  end
end
