require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @valid_user = users(:valid)
    @invalid_user = users(:invalid)
  end

  test "login with invalid credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @invalid_user.email, password: "foobar" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @valid_user.email, password: "password" } }
    assert_redirected_to @valid_user
    follow_redirect!
    assert is_logged_in?
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@valid_user)
  end
end
