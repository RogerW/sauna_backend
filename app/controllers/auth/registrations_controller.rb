class Auth::RegistrationsController < Devise::RegistrationsController
  # skip_before_action :authenticate_user!
  before_action :authenticate_user!, only: %i[edit update]

  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save

    if resource.persisted?
      sign_up(resource_name, resource)

      exp = Time.now.to_i + 31 * 24 * 3600 # one month
      exp_payload = {exp: exp, email: current_user.email  }

      token = JWT.encode(exp_payload, ENV['JWT_SECRET_KEY'], 'HS256')

      render json: {
        msg: 'Вы успешно зарегистрировались!',
        current_user: current_user.public_fields,
        jwt: token
      }
    else
      render json: {
        msg: resource.errors.full_messages.first,
        errors: resource.errors
      }, status: 403
    end
  end

  def edit; end
  
  def new; end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name
      render json: {
        msg: 'Вы успешно зарегистрировались!',
        current_app_user: current_user.public_fields
      }
    else
      clean_up_passwords resource
      render json: {
        msg: resource.errors.full_messages.first,
        errors: resource.errors
      }, status: 403
    end
  end

  protected

  def update_resource(resource, params)
    if current_app_user.uid?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password)
  end

  def account_update_params
    params.require(:user).permit(:email, :password)
  end
end
