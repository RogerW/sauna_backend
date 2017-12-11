class SaunaListsController < ApplicationController
  include Spa

  skip_before_action :authenticate_user!, only: %i[index show can_book get_price]
  before_action :set_sauna, only: %i[show update destroy can_book get_price]

  def index
    collection = @model.all

    collection_json = collection.as_json

    result = []

    collection.each_with_index do |e, i|
      result.push collection_json[i].merge(logotype_image: e.logotype.url(:large),
                                           logotype_medium: e.logotype.url(:medium),
                                           logotype_thumb: e.logotype.url(:thumb))
    end

    render json: Oj.dump(
      collection: result
    )
  end

  def can_book
    render json: Oj.dump(reservation.intersection_range)
  end

  def get_price
    render json: Oj.dump(price: reservation.get_cost.to_i)
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
      @model = @model.where(sauna_table[:min_cost_cents].lteq(params[:max_cost])) if params[:max_cost].present?
      @model = @model.where(sauna_table[:max_cost_cents].gteq(params[:min_cost])) if params[:min_cost].present?

      if params[:only_free].present?
        reserv_table = Arel::Table.new(:reservations)

        start_date = Time.current || params[:start_date]
        duration = 2 || params[:duration]
        end_time = start_date + duration.hours

        sauna_ids = Reservation.select(:sauna_id)
                               .where(
                                 'reserv_range && tstzrange(:start, :end)',
                                 start: start_date,
                                 end: end_time
                               )
                               .where(reserv_table[:status].lteq(6))
                               .pluck(:sauna_id)

        @model = @model.where(sauna_table[:id].not_in(sauna_ids))
      end

      if params[:only_own].present?
        if AppUser.current_user.nil?
          sauna_ids = []
        else
          sauna_ids = AppUser.current_user.saunas.all.pluck(:sauna_id)
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
    start_datetime = DateTime.strptime(params[:reservation][:start_date_time], '%Y-%m-%dT%H:%M:%S%z')
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
