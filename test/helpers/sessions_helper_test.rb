require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @valid_user = users(:valid)
    remember(@valid_user)
  end

  test "current_user returns correct user when session is nil" do
    assert_equal @valid_user, current_user
    assert is_logged_in?
  end

  test "current_user return nil when remember digest is wrong" do
    @valid_user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end