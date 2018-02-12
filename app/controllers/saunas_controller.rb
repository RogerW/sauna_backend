class SaunasController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show]

  def get_contacts
    @sauna = Sauna.find(params[:id])
    authorize @sauna, :get_contacts?

    @collection = @sauna.contacts.all
    
    render json: Oj.dump(
      collection: @collection
    )
  end

  def show
    render json: Oj.dump(
      collection: @resource.as_json.merge(logotype_image: @resource.logotype.url(:large),
                                          logotype_medium: @resource.logotype.url(:medium),
                                          logotype_thumb: @resource.logotype.url(:thumb)),
      single: true
    )
  end

  def create

    full_address = Sauna.find_by_sql(['select fsfn_AddressObjects_TreeActualName(?) as full_address', params[:sauna][:street_uuid]]).first.full_address
    # street = Addrobj.where(aoguid: params[:sauna][:street_uuid]).first.formalname

    @resource = @model.new(resource_params
      .merge(full_address: full_address + ', д ' + params[:sauna][:house]))

    authorize @resource

    # @resource = @model.new resource_params

    if params[:sauna][:logotype] != '' && params[:sauna][:logotype][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:sauna][:logotype][:filetype]};base64,#{params[:sauna][:logotype][:value]}")
      image_file.original_filename = params[:sauna][:logotype][:filename]
      image_file.content_type      = params[:sauna][:logotype][:filetype]
      @resource.logotype           = image_file
    end

    if @resource.save
      @resource.create_sauna_description(description: params[:sauna][:description])

      AppUser.current_user.saunas << @resource
      render json: { msg: 'Сауна успешно создана. Ожидайте проверки модератором!' }
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  def update
    authorize @resource, :update?

    full_address = Sauna.find_by_sql(['select fsfn_AddressObjects_TreeActualName(?) as full_address', params[:sauna][:street_uuid]]).first.full_address
    # street = Addrobj.where(aoguid: params[:sauna][:street_uuid]).first.formalname

    @resource.assign_attributes(resource_params)
    @resource.full_address = full_address + ', д ' + params[:sauna][:house]

    if params[:sauna][:logotype] != '' && params[:sauna][:logotype][:value]
      image_file                   = Paperclip.io_adapters.for("data:#{params[:sauna][:logotype][:filetype]};base64,#{params[:sauna][:logotype][:value]}")
      image_file.original_filename = params[:sauna][:logotype][:filename]
      image_file.content_type      = params[:sauna][:logotype][:filetype]
      @resource.logotype           = image_file
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
    @model = if AppUser.current_user
               AppUser.current_user.saunas
             else
               Sauna
             end
  end

  def decode_base64
    decoded_data = Base64.decode64(params[:sauna][:logotype][:value])
    StringIO.new(decoded_data)
    end

  # Only allow a trusted parameter "white list" through.
  def resource_params
    params.require(:sauna).permit(
      :name, :house, :lat, :lon, :notes, :street_uuid
    )
  end
end
