require 'test_helper'

class SaunasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sauna = saunas(:one)
  end

  test "should get index" do
    get saunas_url, as: :json
    assert_response :success
  end

  test "should create sauna" do
    assert_difference('Sauna.count') do
      post saunas_url, params: { sauna: { address_id: @sauna.address_id, city_id: @sauna.city_id, logo: @sauna.logo, name: @sauna.name, rating: @sauna.rating } }, as: :json
    end

    assert_response 201
  end

  test "should show sauna" do
    get sauna_url(@sauna), as: :json
    assert_response :success
  end

  test "should update sauna" do
    patch sauna_url(@sauna), params: { sauna: { address_id: @sauna.address_id, city_id: @sauna.city_id, logo: @sauna.logo, name: @sauna.name, rating: @sauna.rating } }, as: :json
    assert_response 200
  end

  test "should destroy sauna" do
    assert_difference('Sauna.count', -1) do
      delete sauna_url(@sauna), as: :json
    end

    assert_response 204
  end
end
