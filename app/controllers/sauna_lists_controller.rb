class SaunaListsController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show can_book get_price]
  before_action :set_sauna, only: %i[show update destroy can_book get_price]

  def index
    collection = @model.all

    collection_json = collection.as_json

    result = []

    collection.each_with_index do |e, i|
      sauna = Sauna.find e.id
      result.push collection_json[i].merge(logotype_image: sauna.logotype.url(:large),
                                           logotype_image_webp: sauna.logotype.url(:large_webp),
                                           logotype_image_md: sauna.logotype.url(:large_md),
                                           logotype_image_md_webp: sauna.logotype.url(:large__md_webp),
                                           logotype_medium: sauna.logotype.url(:medium),
                                           logotype_medium_webp: sauna.logotype.url(:medium_webp),
                                           logotype_thumb: sauna.logotype.url(:thumb),
                                           logotype_thumb_webp: sauna.logotype.url(:thumb_webp))
    end

    render json: Oj.dump(
      collection: result
    )
  end

  def show
    # @resource = @model.take(params[:id])
    sauna = Sauna.find @resource.id
    render json: Oj.dump(
      collection: @resource
        .as_json.merge(logotype_image: sauna.logotype.url(:large),
                       logotype_image_webp: sauna.logotype.url(:large_webp),
                       logotype_image_md: sauna.logotype.url(:large_md),
                       logotype_image__md_webp: sauna.logotype.url(:large__md_webp),
                       logotype_medium: sauna.logotype.url(:medium),
                       logotype_medium_webp: sauna.logotype.url(:medium_webp),
                       logotype_thumb: sauna.logotype.url(:thumb),
                       logotype_thumb_webp: sauna.logotype.url(:thumb_webp)),
      single: true
    )
  end

  def can_book
    render json: Oj.dump(reservation.intersection_range)
  end

  def get_price
    render json: Oj.dump(
      price: reservation.get_cost.to_i,
      can_book: Reservation.intersection_range(
        reservations_params[:reserv_range],
        0,
        params[:id]
      ).empty?
    )
  end

  def get_list_by_admin
    sauna_ids = UsersSauna.where(user_id: user.id).all.pluck(:sauna_id)
    sauna_table = Arel::Table(:saunas)

    render json: Oj.dump(collection: Sauna.where(sauna_table[:id].in(sauna_ids)))
  end

  private

  def set_model
    sauna_table = Arel::Table.new(:sauna_lists)
    @model = SaunaList

    if action_name.include? 'index'
      if params[:max_cost].present?
        @model = @model.where(sauna_table[:min_cost_cents]
          .lteq(params[:max_cost]
          .to_s.to_i * 100))
      end

      if params[:min_cost].present?
        @model = @model.where(sauna_table[:max_cost_cents]
          .gteq(params[:min_cost]
          .to_s.to_i * 100))
      end

      if params[:only_free].present?
        reserv_table = Arel::Table.new(:reservations)

        start_date = Time.strptime("#{params[:start_date]}T#{params[:start_time]}", '%Y-%m-%dT%H:%M') || Time.current

        # puts Time.strptime("#{params[:start_date]}T#{params[:start_time]}", '%Y-%m-%dT%H:%M')
        # puts start_date

        duration = params[:duration].to_s.to_i || 2
        end_time = start_date + duration.hours

        sauna_ids = Reservation.select(:sauna_id)
                               .where(
                                 'reserv_range && tsrange(:start, :end)',
                                 start: start_date,
                                 end: end_time
                               )
                               .where(
                                 reserv_table[:aasm_state].not_in(
                                   %w[canceled_by_user canceled_by_admin canceled_by_system]
                                 )
                               )
                               .pluck(:sauna_id)

        @model = @model.where(sauna_table[:id].not_in(sauna_ids))
      end

      if params[:only_own].present?
        sauna_ids = if AppUser.current_user.nil?
                      []
                    else
                      # sauna_ids = UsersSauna.where(user_id: user.id).all.pluck(:sauna_id)
                      AppUser.current_user.saunas.all.pluck(:sauna_id)
                    end
        puts sauna_ids
        @model = @model.where(sauna_table[:id].in(sauna_ids))
      end
    end
  end

  def reservation
    @sauna.reservations.build(reservations_params)
  end

  def set_sauna
    @sauna = Sauna.find(params[:id])
  end

  def reservations_params
    # puts "|#{params[:reservation][:start_date_time]}|"
    start_datetime = Time.strptime(params[:reservation][:start_date_time], '%FT%R:%S')
    end_datetime = start_datetime + params[:reservation][:duration].to_i.hours

    params.require(:reservation)
          .permit(:guests_num)
          .merge(reserv_range: start_datetime...end_datetime)
  end

  # Only allow a trusted parameter "white list" through.
  def address_params
    params.require(:address).permit(:street, :city_id, :house, :lat, :lon, :notes)
  end
end
