require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:lana)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    #invalid micropost submit
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: " " } }
    end
    assert_select 'div#error_explanation'
    #valid micropost submit
    content = "This is valid content for a micropost"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #delete a micropost
    assert_select 'a', text: 'delete'
    last_micropost = @user.microposts.most_recent.last
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(last_micropost)
    end
    #no delete links on different user page
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

end
