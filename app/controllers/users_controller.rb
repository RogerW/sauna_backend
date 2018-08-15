class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_password
    @user = AppUser.current_user

    resource = @user.update(user_params)
    if resource
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      render json: {
        msg: 'Пароль успешно обновлен'
      }
    else
      render json: {
        msg: resource.errors.full_messages.first,
        errors: resource.errors
      }, status: 403
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
