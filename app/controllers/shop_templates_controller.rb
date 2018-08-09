class ShopTemplatesController < ApplicationController
  def index
    authorize ShopTemplate

    render json: Oj.dump(
      collection: ShopTemplate.where(type_tmpl: 'sauna')
    )
  end
end
