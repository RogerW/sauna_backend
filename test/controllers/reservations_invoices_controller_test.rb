require 'test_helper'

class ReservationsInvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservations_invoice = reservations_invoices(:one)
  end

  test "should get index" do
    get reservations_invoices_url, as: :json
    assert_response :success
  end

  test "should create reservations_invoice" do
    assert_difference('ReservationsInvoice.count') do
      post reservations_invoices_url, params: { reservations_invoice: { invoice_id: @reservations_invoice.invoice_id, reservation_id: @reservations_invoice.reservation_id } }, as: :json
    end

    assert_response 201
  end

  test "should show reservations_invoice" do
    get reservations_invoice_url(@reservations_invoice), as: :json
    assert_response :success
  end

  test "should update reservations_invoice" do
    patch reservations_invoice_url(@reservations_invoice), params: { reservations_invoice: { invoice_id: @reservations_invoice.invoice_id, reservation_id: @reservations_invoice.reservation_id } }, as: :json
    assert_response 200
  end

  test "should destroy reservations_invoice" do
    assert_difference('ReservationsInvoice.count', -1) do
      delete reservations_invoice_url(@reservations_invoice), as: :json
    end

    assert_response 204
  end
end
