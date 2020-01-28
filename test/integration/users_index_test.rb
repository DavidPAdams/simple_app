require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:lana) 
  end

  test "index action should list users with pagination and delete for admin" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
  end

  test "delete by admin should remove target user" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index action does not show delete links for non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
