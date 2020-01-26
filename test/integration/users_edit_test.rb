require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @valid_user = users(:valid)
  end

  test "unsuccessful profile edit" do
    log_in_as(@valid_user)
    get edit_user_path(@valid_user)
    assert_template "users/edit"
    patch user_path(@valid_user), params: {
                                    user: { 
                                      name: "",
                                      email: "bad@place",
                                      password: "not",
                                      password_confirmation: "ton" } }
    assert_template "users/edit"
    assert_select "div#error_explanation"
    assert_select 'div.field_with_errors', count: 8
  end

  test "successful profile edit" do
    log_in_as(@valid_user)
    get edit_user_path(@valid_user)
    assert_template "users/edit"
    patch user_path(@valid_user), params: {
                                    user: { 
                                      name: "Jack Frost",
                                      email: "icy@snowcave.com",
                                      password: "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @valid_user
    @valid_user.reload
    assert_equal "Jack Frost", @valid_user.name
    assert_equal "icy@snowcave.com", @valid_user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@valid_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@valid_user), params: {
                                    user: { 
                                      name: "Jack Frost",
                                      email: "icy@snowcave.com",
                                      password: "",
                                      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
end
 