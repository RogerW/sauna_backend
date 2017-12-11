require 'test_helper'

class SaunaDescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sauna_description = sauna_descriptions(:one)
  end

  test "should get index" do
    get sauna_descriptions_url, as: :json
    assert_response :success
  end

  test "should create sauna_description" do
    assert_difference('SaunaDescription.count') do
      post sauna_descriptions_url, params: { sauna_description: { description: @sauna_description.description, sauna_id: @sauna_description.sauna_id, services: @sauna_description.services } }, as: :json
    end

    assert_response 201
  end

  test "should show sauna_description" do
    get sauna_description_url(@sauna_description), as: :json
    assert_response :success
  end

  test "should update sauna_description" do
    patch sauna_description_url(@sauna_description), params: { sauna_description: { description: @sauna_description.description, sauna_id: @sauna_description.sauna_id, services: @sauna_description.services } }, as: :json
    assert_response 200
  end

  test "should destroy sauna_description" do
    assert_difference('SaunaDescription.count', -1) do
      delete sauna_description_url(@sauna_description), as: :json
    end

    assert_response 204
  end
end
