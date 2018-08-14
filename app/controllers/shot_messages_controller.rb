class ShotMessagesController < ApplicationController
  before_action :set_shot_message, only: [:show, :update, :destroy]

  # GET /shot_messages
  def index
    @shot_messages = ShotMessage.all

    render json: @shot_messages
  end

  # GET /shot_messages/1
  def show
    render json: @shot_message
  end

  # POST /shot_messages
  def create
    @shot_message = ShotMessage.new(shot_message_params)

    if @shot_message.save
      render json: @shot_message, status: :created, location: @shot_message
    else
      render json: @shot_message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shot_messages/1
  def update
    if @shot_message.update(shot_message_params)
      render json: @shot_message
    else
      render json: @shot_message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shot_messages/1
  def destroy
    @shot_message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shot_message
      @shot_message = ShotMessage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shot_message_params
      params.require(:shot_message).permit(:user_id, :content, :code, :status, :retries, :phone, :next_at)
    end
end
