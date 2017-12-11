class SaunaGalleriesController < ApplicationController
  before_action :set_sauna_gallery, only: [:show, :update, :destroy]

  # GET /sauna_galleries
  def index
    @sauna_galleries = SaunaGallery.all

    render json: @sauna_galleries
  end

  # GET /sauna_galleries/1
  def show
    render json: @sauna_gallery
  end

  # POST /sauna_galleries
  def create
    @sauna_gallery = SaunaGallery.new(sauna_gallery_params)

    if @sauna_gallery.save
      render json: @sauna_gallery, status: :created, location: @sauna_gallery
    else
      render json: @sauna_gallery.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sauna_galleries/1
  def update
    if @sauna_gallery.update(sauna_gallery_params)
      render json: @sauna_gallery
    else
      render json: @sauna_gallery.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sauna_galleries/1
  def destroy
    @sauna_gallery.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sauna_gallery
      @sauna_gallery = SaunaGallery.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sauna_gallery_params
      params.require(:sauna_gallery).permit(:sauna_id, :photo)
    end
end
