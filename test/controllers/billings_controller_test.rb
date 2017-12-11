require 'test_helper'

class BillingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing = billings(:one)
  end

  test "should get index" do
    get billings_url, as: :json
    assert_response :success
  end

  test "should create billing" do
    assert_difference('Billing.count') do
      post billings_url, params: { billing: { cost: @billing.cost, day_type: @billing.day_type, end_time: @billing.end_time, sauna_id: @billing.sauna_id, start_time: @billing.start_time } }, as: :json
    end

    assert_response 201
  end

  test "should show billing" do
    get billing_url(@billing), as: :json
    assert_response :success
  end

  test "should update billing" do
    patch billing_url(@billing), params: { billing: { cost: @billing.cost, day_type: @billing.day_type, end_time: @billing.end_time, sauna_id: @billing.sauna_id, start_time: @billing.start_time } }, as: :json
    assert_response 200
  end

  test "should destroy billing" do
    assert_difference('Billing.count', -1) do
      delete billing_url(@billing), as: :json
    end

    assert_response 204
  end
end
