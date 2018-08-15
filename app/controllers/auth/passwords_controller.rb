class Auth::PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  skip_before_action :authenticate_user!
  # Render the #edit only if coming from a reset password email link
  # append_before_action :assert_reset_token_passed, only: :edit

  # POST /resource/password
  def create
    resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render json: {
        msg: 'Вам были отправлены инструкции по восстановлению пароля'
      }
    else
      render json: {
        msg: resource.errors.full_messages.first,
        errors: resource.errors
      }, status: 403
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit; end

  # PUT /resource/password
  def update
    resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        sign_in(resource_name, resource)
        render json: {
          msg: resource.active_for_authentication? ? :updated : :updated_not_active,
        }
      else
        render json: {
          msg: resource.errors.full_messages.first,
          errors: set_flash_message!(:notice, :updated_not_active)
        }, status: 403
      end
    else
      set_minimum_password_length
      render json: {
        msg: resource.errors.full_messages.first,
        errors: resource.errors
      }, status: 403
    end
  end

  def update_password
    @user = AppUser.current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      render json: {
          msg: "Пароль успешно обновлен",
        }
    else
      render json: {
        msg: "Неверный текущий пароль",
        errors: "Неверный текущий пароль"
      }, status: 403
    end
  end

  protected

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end

  # Check if a reset_password_token is provided in the request
  def assert_reset_token_passed
    if params[:reset_password_token].blank?
      set_flash_message(:alert, :no_token)
      redirect_to new_session_path(resource_name)
    end
  end

  # Check if proper Lockable module methods are present & unlock strategy
  # allows to unlock resource on password reset
  def unlockable?(resource)
    resource.respond_to?(:unlock_access!) &&
      resource.respond_to?(:unlock_strategy_enabled?) &&
      resource.unlock_strategy_enabled?(:email)
  end

  def translation_scope
    'devise.passwords'
  end
end
