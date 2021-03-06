require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:lana)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'
    #invalid micropost submit
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: " " } }
    end
    assert_select 'div#error_explanation'
    #valid micropost submit
    content = "This is valid content for a micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
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

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    #user with no microposts
    loser_user = users(:malory)
    log_in_as(loser_user)
    get root_path
    assert_match "0 microposts", response.body
    #user has one micropost
    loser_user.microposts.create!(content: "I'm not a loser!")
    get root_path
    assert_match "1 micropost", response.body
  end

end
