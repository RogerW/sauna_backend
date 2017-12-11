class UsersSaunasController < ApplicationController
  before_action :set_users_sauna, only: [:show, :update, :destroy]

  # GET /users_saunas
  def index
    @users_saunas = UsersSauna.all

    render json: @users_saunas
  end

  # GET /users_saunas/1
  def show
    render json: @users_sauna
  end

  # POST /users_saunas
  def create
    @users_sauna = UsersSauna.new(users_sauna_params)

    if @users_sauna.save
      render json: @users_sauna, status: :created, location: @users_sauna
    else
      render json: @users_sauna.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users_saunas/1
  def update
    if @users_sauna.update(users_sauna_params)
      render json: @users_sauna
    else
      render json: @users_sauna.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users_saunas/1
  def destroy
    @users_sauna.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_sauna
      @users_sauna = UsersSauna.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def users_sauna_params
      params.require(:users_sauna).permit(:user_id, :sauna_id)
    end
end
