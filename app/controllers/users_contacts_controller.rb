class UsersContactsController < ApplicationController
  def show
    allow_columns = %w[last_name first_name middle_name phone]

    render json: Oj.dump(
      collection: AppUser.current_user.contact.as_json.delete_if { |k, _v| !allow_columns.include? k },
      single: true
    )
  end

  def create
    unless AppUser.current_user.contact
      @resource = AppUser.current_user.create_contact(resource_params)
    end

    if AppUser.current_user.contact.update(resource_params)
      render json: { msg: 'Контактные данные успешно обновлены.' }
    else
      render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
    end
  end

  private

  def resource_params
    params.require(:contacts)
          .permit(:last_name, :first_name, :middle_name, :phone)
  end
end
