require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  
  should belong_to(:user)
  should belong_to(:friend)
  
  test "that creating a friendship works" do
    assert_nothing_raised do
      UserFriendship.create user: users(:dummy_test_user_01), friend: users(:mikethefrog)
    end
  end
  
  test "that creating a friendship based on user id and friend id works" do
    UserFriendship.create user_id: users(:dummy_test_user_01).id, friend_id: users(:mikethefrog).id
    assert users(:dummy_test_user_01).friends.include?(users(:mikethefrog))
  end
end
