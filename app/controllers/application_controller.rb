class AppUser
  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
  end
end

class ApplicationController < ActionController::API
  include Pundit

  before_action :set_current_user
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    AppUser.current_user
  end

  protected

  def user_not_authorized
    render json: { msg: 'Нет прав на данное действие!', error: true }, status: 403
  end

  private

  # def set_current_user
  #   AppUser.current_user = if request.headers['X-Anonymous-Consumer'] ||
  #                          request.headers['X-Consumer-Custom-ID'].nil?

  #                          User.find(1)
  #                       else
  #                         User.find(request.headers['X-Consumer-Custom-ID'])
  #                       end
  # end

  def set_current_user
    begin
      # token = request.headers['authorization'].to_s.split(' ').last
      token = params[:jwt]
      decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')
      puts decoded_token
      email = decoded_token[0]['email']
      AppUser.current_user = User.find_by_email(email)
    rescue JWT::ExpiredSignature
      puts 'ExpiredSignature'
      AppUser.current_user = nil
    rescue JWT::DecodeError
      puts 'DecodeError'
      AppUser.current_user = nil
    end
  end

  def authenticate_user!
    render json: { msg: 'Вы не авторизованы!', error: true }, status: 401 unless AppUser.current_user
    # render json: { msg:  User.find(2) }, status: 403 unless AppUser.current_user
  end
end
