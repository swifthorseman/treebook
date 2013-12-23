require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
  
  def sign_in_as(user, password)
    post login_path, user: {email: user.email, password: password}
  end
  
  test "adding a friend" do
    sign_in_as users(:dummy_test_user_01), "testing"
    
    get "/user_friendships/new?friend_id=#{users(:mikethefrog).profile_name}"
    assert_response :success
    
    assert_difference 'UserFriendship.count', 2 do
      post "/user_friendships", user_friendship: {friend_id: users(:mikethefrog).profile_name}
      assert_response :redirect
      assert_equal "Friend request sent.", flash[:success]
    end
  end
  
end
