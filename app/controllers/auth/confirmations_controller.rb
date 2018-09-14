# frozen_string_literal: true

class Auth::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :authenticate_user!, only: %i[show]
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      confirm
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    @confirmable.only_if_unconfirmed { yield } unless @confirmable.new_record?
  end

  def confirm
    @confirmable.confirm

    sign_in resource_name, @confirmable

    hmac_secret = ENV['JWT_SECRET_KEY']

    exp = Time.now.to_i + 31 * 24 * 3600 # one month
    exp_payload = { exp: exp, email: current_user.email, role: current_user.role }

    token = JWT.encode(exp_payload, hmac_secret, 'HS256')

    render json: {
      msg: :confirmed,
      current_user: current_user.public_fields,
      token: token
    }
  end
end
