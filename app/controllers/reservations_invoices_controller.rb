class ReservationsInvoicesController < ApplicationController
  before_action :set_reservations_invoice, only: [:show, :update, :destroy]

  # GET /reservations_invoices
  def index
    @reservations_invoices = ReservationsInvoice.all

    render json: @reservations_invoices
  end

  # GET /reservations_invoices/1
  def show
    render json: @reservations_invoice
  end

  # POST /reservations_invoices
  def create
    @reservations_invoice = ReservationsInvoice.new(reservations_invoice_params)

    if @reservations_invoice.save
      render json: @reservations_invoice, status: :created, location: @reservations_invoice
    else
      render json: @reservations_invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations_invoices/1
  def update
    if @reservations_invoice.update(reservations_invoice_params)
      render json: @reservations_invoice
    else
      render json: @reservations_invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations_invoices/1
  def destroy
    @reservations_invoice.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservations_invoice
      @reservations_invoice = ReservationsInvoice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reservations_invoice_params
      params.require(:reservations_invoice).permit(:invoice_id, :reservation_id)
    end
end
