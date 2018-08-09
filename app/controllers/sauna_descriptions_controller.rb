class SaunaDescriptionsController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    collection = @model

    render json: Oj.dump(
      collection: collection
    )
  end

  def update
    authorize @resource, :update?

    template = ShopTemplate
               .where(type_tmpl: 'sauna')
               .first.template.sort! do |l, r|
      [
        l['priority'], l['section_priority']
      ] <=> [
        r['priority'], r['section_priority']
      ]
    end

    shop_desc = []
    input_json = JSON.parse(resource_params)

    template.each do |t|
      if input_json[t['name']] != '' && !input_json[t['name']].nil?
        t['values'] = input_json[t['name']]
        shop_desc.push t
      end
    end

    # render json: Oj.dump(
    #   template: template,
    #   req: JSON.parse(resource_params)
    # )
    @resource.details = shop_desc
    if @resource.save
      render json: Oj.dump(
        collection: @resource,
        single: true,
        msg: "#{@model.name} успешно обновлен"
      )
    else
      render json: {
        errors: @resource.errors,
        msg: @resource.errors.full_messages.join(', ')
      }, status: 422
    end
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
    # tags = {}

    # params[:sauna_description].try(:fetch, :services, {}).keys.each do |k|
    #   tags[k] = []
    #   params[:sauna_description][:services][k].keys.each do |nk|
    #     tags[k].push nk
    #   end
    # end

    # puts

    params.require(:sauna_description)
  end
end
