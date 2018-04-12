class PromosController < ApplicationController
  include Spa
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    collection = @model
                 .where("localtimestamp <@ promos.active_range")
                 .where('promos.status = 1')

    collection_json = collection.as_json

    result = []
    collection.each_with_index do |e, i|
      result.push collection_json[i].merge(image_medium: e.image.url(:medium),
                                           image_thumb: e.image.url(:thumb))
    end

    render json: Oj.dump(
      collection: result
    )
  end

  def create
    @resource = @model.new resource_params
    authorize @resource

    if params[:promo][:image][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:promo][:image][:filetype]};base64,#{params[:promo][:image][:value]}")
      image_file.original_filename = params[:promo][:image][:filename]
      image_file.content_type      = params[:promo][:image][:filetype]
      @resource.image              = image_file
    end

    if @resource.save
      @collection = @model.where(id: @resource.id)

      render json: { msg: 'Фото добавлено!' }
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  def update
    authorize @resource, :update?

    if params[:promo][:image] != '' && params[:promo][:image][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:promo][:image][:filetype]};base64,#{params[:promo][:image][:value]}")
      image_file.original_filename = params[:promo][:image][:filename]
      image_file.content_type      = params[:promo][:image][:filetype]
      @resource.image              = image_file
    end

    if @resource.save
      render json: Oj.dump(
        collection: @resource,
        single: true,
        msg: "#{@model.name} успешно обновлен"
      )
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  private

  def set_model
    @model = if params[:sauna_id]
               Sauna.find(params[:sauna_id]).promos
             else
               Promo
             end
  end

  def decode_base64
    decoded_data = Base64.decode64(params[:sauna][:logotype][:value])
    StringIO.new(decoded_data)
  end

  # Only allow a trusted parameter "white list" through.
  def resource_params
    params.require(:promo).permit(:title, :sauna_id, :status, :desc)
          .merge(active_range: start_time...end_time)
          .merge(user_id: AppUser.current_user.id)
  end
end
