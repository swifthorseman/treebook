require 'test_helper'
require 'awesome_print'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)
  should have_many(:blocked_user_friendships)
  should have_many(:blocked_friends)
  should have_many(:accepted_user_friendships)
  should have_many(:accepted_friends)
  should have_many(:activities)
  
  test "a user should enter first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end 

  test "a user should should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:dummy_test_user_01).profile_name

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'some', last_name: 'thing', email: 'something@___.com')
    user.password = user.password_confirmation = "password"    
    user.profile_name= "My profile with spaces"

    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'some', last_name: 'thing', email: 'something_else@___.com')
    user.password = user.password_confirmation = "password"
    user.profile_name = "something_else"
    
    assert user.valid?
  end
  
  test "that no error is raised when trying to access a friend list" do
    users(:dummy_test_user_01).friends
  end
  
  test "that creating friendships on a user works" do
    users(:dummy_test_user_01).pending_friends << users(:mikethefrog)
    users(:dummy_test_user_01).pending_friends.reload
    assert users(:dummy_test_user_01).pending_friends.include?(users(:mikethefrog))
  end
  
  test "that calling to_param on a user returns the profile_name" do
    assert_equal "something", users(:dummy_test_user_01).to_param
  end

  context "#has_blocked?" do
    should "return true if a user has blocked another user" do
      assert users(:dummy_test_user_01).has_blocked?(users(:blocked_friend))
    end

    should "return false if a user has not blocked another user" do
      assert !users(:dummy_test_user_01).has_blocked?(users(:mikethefrog))
    end
  end

  context "#create_activity" do
    should "increase the Activity count" do
      assert_difference 'Activity.count' do
        users(:dummy_test_user_01).create_activity(statuses(:one), 'created')
      end
    end

    should "set the targetable instance to the item passed in" do
      activity = users(:dummy_test_user_01).create_activity(statuses(:one), 'created')
      assert_equal statuses(:one), activity.targetable
    end

    should "increase the Activity count with an album" do
      assert_difference 'Activity.count' do
        users(:dummy_test_user_01).create_activity(albums(:vacation), 'created')
      end
    end

    should "set the targetable instance to the item passed in with an album" do
      activity = users(:dummy_test_user_01).create_activity(albums(:vacation), 'created')
      assert_equal albums(:vacation), activity.targetable
    end
  end



end
