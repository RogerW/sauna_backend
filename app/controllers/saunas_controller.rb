class SaunasController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show]

  def get_contacts
    @collection = @sauna.contacts.all

    authorize @sauna, :get_contacts?

    render json: Oj.dump(
      collection: @collection
    )
  end

  def create
    street = Sauna.find_by_sql(['SELECT fstf_AddressObjects_SearchByName(?, NULL, ?) as addr', params[:sauna][:street], params[:sauna][:city]]).first

    full_address = Sauna.find_by_sql(['select fsfn_AddressObjects_TreeActualName(?) as full_address', street.addr.match(/([\d\w\-]+)/)[0]]).first

    @resource = @model.new(resource_params
      .merge(street_uuid: street['addr'].match(/([\d\w\-]+)/)[0])
      .merge(full_address: full_address['full_address']))

    authorize @resource

    # @resource = @model.new resource_params

    if params[:sauna][:logotype][:value]
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
      :name,
      sauna_descriptions_attributes: [:description],
      billings_attributes: %i[day_type start_time end_time]
    )
  end
end
