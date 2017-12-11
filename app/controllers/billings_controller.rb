class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :update, :destroy]

  # GET /billings
  def index
    @billings = Billing.all

    render json: @billings
  end

  # GET /billings/1
  def show
    render json: @billing
  end

  # POST /billings
  def create
    @billing = Billing.new(billing_params)

    if @billing.save
      render json: @billing, status: :created, location: @billing
    else
      render json: @billing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /billings/1
  def update
    if @billing.update(billing_params)
      render json: @billing
    else
      render json: @billing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /billings/1
  def destroy
    @billing.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def billing_params
      params.require(:billing).permit(:sauna_id, :day_type, :start_time, :end_time, :cost)
    end
end
