require 'test_helper'
require 'awesome_print'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  
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
    users(:dummy_test_user_01).friends << users(:mikethefrog)
    users(:dummy_test_user_01).friends.reload
    assert users(:dummy_test_user_01).friends.include?(users(:mikethefrog))
  end

end
