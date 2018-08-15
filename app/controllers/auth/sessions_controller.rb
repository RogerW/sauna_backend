require 'oauth2'

class Auth::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %i[create new vkontacte]
  before_action :set_oauth2, only: %i[new vkontakte]

  class NoRawData < StandardError; end

  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      sign_in resource_name, resource

      render_sign_in current_user
    else
      render json: {
        msg: 'Email не найден, либо пароль неверен', status: 401
      }
    end
  end

  def vkontacte
    token = @client_vk.auth_code.get_token(
      oauth_params, redirect_uri: 'https://cityprice.club/oauth/vk'
    )

    email = token.email
    user_id = token.user_id

    if User.exists(email: email, uid: user_id, provider: 'vkontakte')
      render_sign_in User.where(email: email, uid: user_id, provider: 'vkontakte').first
    else
      user = User.new(
        email: email,
        password: Devise.friendly_token.first(8),
        confirmed_at: Time.now,
        provider: 'vkontacte',
        uid: user_id
      )

      result = token.get('/methods/account.getProfileInfo').parsed['response']
      raise NoRawData, result unless result.is_a?(Array) && result.first
      result = result.first

      if user.save
        user.create_contact(
          first_name: result['first_name'],
          last_name: result['last_name']
        )

        render_sign_in user
      else
        render json: {
          errors: user.errors,
          msg: user.errors.full_messages.join(', ')
        }, status: 422
      end
    end
  end

  def new
    render json: {
      vkontakte: @client_vk.auth_code.authorize_url(
        redirect_uri: 'https://cityprice.club/oauth/vk',
        scope: 'email',
        response_type: 'code',
        v: '5.71'
      )
    }
  end

  def destroy
    # Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    render json: {
      msg: 'Вы вышли из системы.', status: 200
    }
  end

  private

  def set_oauth2
    vk_client_options = {
      site: 'https://api.vk.com/',
      token_url: 'https://oauth.vk.com/access_token',
      authorize_url: 'https://oauth.vk.com/authorize'
    }
    @client_vk = OAuth2::Client.new(
      '6350967',
      'Oe278cHRaVmjFQNlbDyU',
      deep_symbolize(vk_client_options)
    )
  end

  def deep_symbolize(options)
    hash = {}
    options.each do |key, value|
      hash[key.to_sym] = value.is_a?(Hash) ? deep_symbolize(value) : value
    end
    hash
  end

  def oauth_params
    params.require(:code)
  end

  def render_sign_in(user)
    hmac_secret = ENV['JWT_SECRET_KEY']

    exp = Time.now.to_i + 31 * 24 * 3600 # one month
    exp_payload = { exp: exp, email: user.email }

    token = JWT.encode(exp_payload, hmac_secret, 'HS256')

    render json: {
      msg: 'Вы успешно авторизовались в системе',
      current_user: user.public_fields,
      token: token
    }
  end
end
