require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Somebody User",
                                         email: "user1@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.reload.activated?
    #Attempt log in before account activation
    log_in_as(user)
    assert_not user.reload.activated?
    assert_not is_logged_in?
    #Catch case of invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not user.reload.activated?
    assert_not is_logged_in?
    #Catch case of valid token with wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not user.reload.activated?
    assert_not is_logged_in?
    #Log in with valid activation token and valid email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert_select "div.alert.alert-success"
    assert is_logged_in?
  end

end
