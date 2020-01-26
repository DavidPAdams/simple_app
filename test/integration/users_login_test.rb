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

  test "login with valid credentials followed by logout" do
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
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@valid_user), count: 0
  end

  test "login with remember_me" do
    log_in_as(@valid_user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remember me" do
    #login to set the cookie
    log_in_as(@valid_user, remember_me: '1')
    #login again to reset the cookie and verify deleted
    log_in_as(@valid_user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
