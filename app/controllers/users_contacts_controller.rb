class UsersContactsController < ApplicationController
  def show
    if AppUser.current_user.contact.nil?
      render json: Oj.dump(
        collection: {},
        single: true
      )
    else
      render json: Oj.dump(
        collection: AppUser.current_user.contact.as_json.delete_if { |k, _v| !allow_columns.include? k },
        single: true
      )
    end
  end

  def create
    unless AppUser.current_user.contact
      @resource = AppUser.current_user.create_contact(resource_params)
    end

    if AppUser.current_user.contact.update(resource_params)
      render json: {
        msg: 'Контактные данные успешно обновлены.',
        collection: AppUser.current_user.contact.as_json(only: allow_columns),
        single: true
      }
    else
      render json: {
        errors: @resource.errors,
        msg: @resource.errors.full_messages.join(', ')
      }, status: 422
    end
  end

  def confirm_phone
    if AppUser.current_user.contact.code_retry_count > 3
      AppUser.current_user
             .contact
             .update(confirm_code: (0...4).map { (1..9).to_a[rand(9)] }.join)

      render json: {
        errors: 'Превышено количество попыток',
        msg: 'Превышено количество попыток. Запросите СМС с новым кодом'
      }, status: 401
    elsif AppUser.current_user.contact.confirm_code == params[:code]
      AppUser.current_user
             .contact
             .update(confirmed_at: Time.now)

      render json: {
        msg: 'Номер подтвержден.',
        collection: AppUser.current_user.contact.as_json(only: allow_columns)
      }
    else
      AppUser.current_user
             .contact
             .update(
               code_retry_count: (AppUser.current_user.contact.code_retry_count + 1)
             )

      render json: {
        errors: 'Неверный код',
        msg: 'Неверный код.'
      }, status: 402
    end
  end

  def send_sms
    if !AppUser.current_user.contact.confirm_send_at.nil? &&
       Time.now - AppUser.current_user.contact.confirm_send_at < 1.minutes
      render json: {
        errors: 'Невозможно отправить СМС',
        msg: 'Отправка кода возможна не чаще раза в минуту.'
      }, status: 401
    elsif AppUser.current_user.contact.code_send_count > 5
      AppUser.current_user.contact.update(
        code_send_count: 0,
        confirm_send_at: Time.now + 1.hours
      )
      render json: {
        errors: 'Превышено количество отправленных СМС',
        msg: 'Превышено количество отправленных СМС. Попробуйте повторить через час.'
      }, status: 402
    else
      if AppUser.current_user.contact.update(
        phone: params[:phone],
        code_send_count: AppUser.current_user.contact.code_send_count + 1,
        confirm_send_at: Time.now
      )
        AppUser.current_user.shot_messages.create(
          content: 'Для подтверждения введите' +
            AppUser.current_user.contact.confirm_code +
            '. cityprice.club',
          phone: params[:phone]
        )

        render json: {
          msg: 'Код подтверждения выслан на указанный телефон.',
          collection: AppUser.current_user.contact.as_json(only: allow_columns),
          single: true
        }
      else
        render json: {
          errors: @resource.errors,
          msg: @resource.errors.full_messages.join(', ')
        }, status: 422
      end
    end
  end

  private

  def resource_params
    params.require(:contacts)
          .permit(:last_name, :first_name, :middle_name, :phone)
  end

  def allow_columns
    %w[last_name first_name middle_name phone confirmed_at confirm_send_at]
  end
end
