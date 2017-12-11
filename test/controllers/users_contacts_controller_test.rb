require 'test_helper'

class UsersContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @users_contact = users_contacts(:one)
  end

  test "should get index" do
    get users_contacts_url, as: :json
    assert_response :success
  end

  test "should create users_contact" do
    assert_difference('UsersContact.count') do
      post users_contacts_url, params: { users_contact: { contact_id: @users_contact.contact_id, user_id: @users_contact.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show users_contact" do
    get users_contact_url(@users_contact), as: :json
    assert_response :success
  end

  test "should update users_contact" do
    patch users_contact_url(@users_contact), params: { users_contact: { contact_id: @users_contact.contact_id, user_id: @users_contact.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy users_contact" do
    assert_difference('UsersContact.count', -1) do
      delete users_contact_url(@users_contact), as: :json
    end

    assert_response 204
  end
end
