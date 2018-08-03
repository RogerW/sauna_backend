class SaunaGalleriesController < ApplicationController
  include Spa
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    collection = @model.all

    collection_json = collection.as_json

    result = []
    collection.each_with_index do |e, i|
      result.push collection_json[i].merge(photo_image: e.photo.url(:large),
                                           photo_image_webp: e.photo.url(:large_webp),
                                           photo_image_md: e.photo.url(:large_md),
                                           photo_image_md_webp: e.photo.url(:large__md_webp),
                                           photo_medium: e.photo.url(:medium),
                                           photo_medium_webp: e.photo.url(:medium_webp),
                                           photo_thumb: e.photo.url(:thumb),
                                           photo_thumb_webp: e.photo.url(:thumb_webp))
    end

    render json: Oj.dump(
      collection: result
    )
  end

  def create
    @resource = @model.new resource_params
    authorize @resource

    if params[:sauna_gallery][:photo][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:sauna_gallery][:photo][:filetype]};base64,#{params[:sauna_gallery][:photo][:value]}")
      image_file.original_filename = params[:sauna_gallery][:photo][:filename]
      image_file.content_type      = params[:sauna_gallery][:photo][:filetype]
      @resource.photo              = image_file
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

    if params[:sauna_gallery][:photo] != '' && params[:sauna_gallery][:photo][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:sauna_gallery][:photo][:filetype]};base64,#{params[:sauna_gallery][:photo][:value]}")
      image_file.original_filename = params[:sauna_gallery][:photo][:filename]
      image_file.content_type      = params[:sauna_gallery][:photo][:filetype]
      @resource.photo              = image_file
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
                Sauna.find(params[:sauna_id]).sauna_galleries
              else
                SaunaGallery
              end
    end

    def decode_base64
      decoded_data = Base64.decode64(params[:sauna][:logotype][:value])
      StringIO.new(decoded_data)
      end

    # Only allow a trusted parameter "white list" through.
    def resource_params
      params.require(:sauna_gallery).permit(:photo)
    end
end
