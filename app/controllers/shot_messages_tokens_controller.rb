class ShotMessagesTokensController < ApplicationController
  before_action :set_shot_messages_token, only: [:show, :update, :destroy]

  # GET /shot_messages_tokens
  def index
    @shot_messages_tokens = ShotMessagesToken.all

    render json: @shot_messages_tokens
  end

  # GET /shot_messages_tokens/1
  def show
    render json: @shot_messages_token
  end

  # POST /shot_messages_tokens
  def create
    @shot_messages_token = ShotMessagesToken.new(shot_messages_token_params)

    if @shot_messages_token.save
      render json: @shot_messages_token, status: :created, location: @shot_messages_token
    else
      render json: @shot_messages_token.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shot_messages_tokens/1
  def update
    if @shot_messages_token.update(shot_messages_token_params)
      render json: @shot_messages_token
    else
      render json: @shot_messages_token.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shot_messages_tokens/1
  def destroy
    @shot_messages_token.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shot_messages_token
      @shot_messages_token = ShotMessagesToken.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shot_messages_token_params
      params.require(:shot_messages_token).permit(:token)
    end
end
