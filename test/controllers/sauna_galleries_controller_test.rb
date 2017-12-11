require 'test_helper'

class SaunaGalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sauna_gallery = sauna_galleries(:one)
  end

  test "should get index" do
    get sauna_galleries_url, as: :json
    assert_response :success
  end

  test "should create sauna_gallery" do
    assert_difference('SaunaGallery.count') do
      post sauna_galleries_url, params: { sauna_gallery: { photo: @sauna_gallery.photo, sauna_id: @sauna_gallery.sauna_id } }, as: :json
    end

    assert_response 201
  end

  test "should show sauna_gallery" do
    get sauna_gallery_url(@sauna_gallery), as: :json
    assert_response :success
  end

  test "should update sauna_gallery" do
    patch sauna_gallery_url(@sauna_gallery), params: { sauna_gallery: { photo: @sauna_gallery.photo, sauna_id: @sauna_gallery.sauna_id } }, as: :json
    assert_response 200
  end

  test "should destroy sauna_gallery" do
    assert_difference('SaunaGallery.count', -1) do
      delete sauna_gallery_url(@sauna_gallery), as: :json
    end

    assert_response 204
  end
end
