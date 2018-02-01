require 'oauth2'
# OAuth session starter
class Auth::OauthController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[vkontakte]
  before_action :set_oauth2, only: %i[vkontakte]

  def vkontakte
    verifier = params['code']
    token = @client_vk.auth_code.get_token(
      verifier, redirect_uri: 'https://cityprice.club/oauth/vk'
    )

    # puts token.params['email']

    email = token.params['email']
    user_id = token.params['user_id']

    puts "token #{token.methods}"
    puts token.token

    user = User.where(email: email, uid: user_id, provider: 'vkontakte')

    if user.any?
      render_sign_in user.first
    else
      user = User.new(
        email: email,
        password: Devise.friendly_token.first(8),
        confirmed_at: Time.now,
        provider: 'vkontakte',
        uid: user_id
      )

      params = {
        fields: info_options,
        v: '5.71'
      }

      result = token.get('/method/users.get', params: params).parsed['response']

      puts "result #{result}"
      # puts "parsered #{result.status}"
      raise result unless result.is_a?(Array) && result.first

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

  private

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

  def set_oauth2
    vk_client_options = {
      site: 'https://api.vk.com/',
      token_url: 'https://oauth.vk.com/access_token',
      authorize_url: 'https://oauth.vk.com/authorize'
    }
    @client_vk = OAuth2::Client.new(
      '6350967',
      'PTEqoleimmTQvANSO1dF',
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

  def info_options
    # http://vk.com/dev/fields
    fields = %w[nickname screen_name sex city country online bdate photo_50 photo_100 photo_200 photo_200_orig photo_400_orig]
    fields.join(',')
  end
end
