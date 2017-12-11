require 'test_helper'

class UsersSaunasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @users_sauna = users_saunas(:one)
  end

  test "should get index" do
    get users_saunas_url, as: :json
    assert_response :success
  end

  test "should create users_sauna" do
    assert_difference('UsersSauna.count') do
      post users_saunas_url, params: { users_sauna: { sauna_id: @users_sauna.sauna_id, user_id: @users_sauna.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show users_sauna" do
    get users_sauna_url(@users_sauna), as: :json
    assert_response :success
  end

  test "should update users_sauna" do
    patch users_sauna_url(@users_sauna), params: { users_sauna: { sauna_id: @users_sauna.sauna_id, user_id: @users_sauna.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy users_sauna" do
    assert_difference('UsersSauna.count', -1) do
      delete users_sauna_url(@users_sauna), as: :json
    end

    assert_response 204
  end
end
