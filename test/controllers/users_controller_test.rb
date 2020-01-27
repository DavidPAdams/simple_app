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

end
