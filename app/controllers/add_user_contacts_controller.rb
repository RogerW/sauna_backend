class AddUserContactsController < ApplicationController
  
  def create
    unless AppUser.current_user.contact
      @resource = AppUser.current_user.create_contact(resource_params)

    if @resource.update(resource_params)
      render json: Oj.dump(@resource)
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
