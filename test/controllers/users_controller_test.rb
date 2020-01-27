require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @valid_user = users(:valid)
    @other_user = users(:teapot)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @other_user
    get edit_user_path(@valid_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @other_user
    patch user_path(@valid_user), params: {
                                    user: { 
                                      name: "Jack Frost",
                                      email: "icy@snowcave.com",
                                      password: "",
                                      password_confirmation: "" } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index to login when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: "password",
                                                    password_confirmation: "password",
                                                    admin: true } }
    assert_not @other_user.admin?
  end

end
