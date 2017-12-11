class Auth::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %i[ create ]
  # skip_before_action :set_current_user, only: %i[ create ]

  def create
    puts "session create"
    puts auth_options
    self.resource = warden.authenticate(auth_options)

    puts warden.authenticate(auth_options)

    if resource
      sign_in resource_name, resource

      hmac_secret = ENV['JWT_SECRET_KEY']

      exp = Time.now.to_i + 31 * 24 * 3600 # one month
      exp_payload = { exp: exp, email: current_user.email }

      token = JWT.encode(exp_payload, hmac_secret, 'HS256')

      render json: {
        msg: 'Вы успешно авторизовались в системе',
        current_user: current_user.public_fields,
        token: token
      }
    else
      render json: {
        msg: 'Email не найден, либо пароль неверен', status: 401
      }
    end
  end

  def new; end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
  end
end
