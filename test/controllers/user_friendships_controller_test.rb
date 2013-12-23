require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  include ActionView::Helpers::DateHelper

  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:dummy_test_user_01), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:dummy_test_user_01), friend: create(:user, first_name: 'Active', last_name: 'Friend'))
        @friendship3 = create(:requested_user_friendship, user: users(:dummy_test_user_01), friend: create(:user, first_name: 'Requested', last_name: 'Friend'))
        @friendship4 = user_friendships(:blocked_by_dummy_test_user_01)


        sign_in users(:dummy_test_user_01)
        get :index
      end

      should "get the index page without error" do
        assert_response :success
      end

      should "assign user_friendships" do
        assert assigns(:user_friendship)
      end

      should "display friends' names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship is pending."
        end
      end

      should "display date information on an accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friendship started #{time_ago_in_words(@friendship2.updated_at)} ago."
        end
      end

      context "blocked users" do
        setup do
          get :index, list: 'blocked'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending nor active friends" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display blocked friends" do
          assert_match /Blocked\ Friend/, response.body
        end

      end

      context "pending friendships" do
        setup do
          get :index, list: 'pending'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display blocked nor active friends" do
          assert_no_match /Block\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display pending friendships" do
          assert_match /Pending\ Friend/, response.body
        end

      end

      context "requested friendships" do
        setup do
          get :index, list: 'requested'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display blocked nor active friends" do
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display requested friends" do
          assert_match /Requested\ Friend/, response.body
        end

      end

      context "accepted friendships" do
        setup do
          get :index, list: 'accepted'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display blocked nor requested friends" do
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Requested\ Friend/, response.body
        end

        should "display active friendships" do
          assert_match /Active\ Friend/, response.body
        end

      end


    end
  end

  context "#new" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
      end
    end
    
    context "when logged in" do
      setup do
        sign_in users(:dummy_test_user_01)
      end
      
      should "get new and return success" do
        get :new
        assert_response :success
      end
      
      should "should set a flash error if the friend_id params is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end
      
      should "display the friend's name" do
        get :new, friend_id: users(:mikethefrog)
        assert_match /#{users(:mikethefrog).full_name}/, response.body
      end
      
      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:mikethefrog)
        assert_equal users(:mikethefrog), assigns(:user_friendship).friend
      end
      
      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:mikethefrog)
        assert_equal users(:dummy_test_user_01), assigns(:user_friendship).user
      end
      
      should "return a 404 status if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end
      
      should "ask if you really want to add as friend" do
        get :new, friend_id: users(:mikethefrog)
        assert_match /Do you really want to add #{users(:mikethefrog).full_name} as a friend\?/, response.body
      end
    end
  end
  
  
  context "#create" do
    
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end
    
    context "when logged in" do
      setup do
        sign_in users(:dummy_test_user_01)
      end
      
      context "with no friend_id" do
        setup do
          post :create
        end
        
        should "set the flash error message" do
          assert !flash[:error].empty?
        end
        
        should "redirect to the root path" do
          assert_redirected_to root_path
        end
      end

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: {friend_id: users(:mikethefrog).profile_name}
          end
        end
      end
      
      
      context "with a valid friend_id" do
        setup do          
          post :create, user_friendship: { friend_id: users(:mikethefrog) }
        end
        
        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mikethefrog), assigns(:friend)
        end
        
        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:dummy_test_user_01), assigns(:user_friendship).user
          assert_equal users(:mikethefrog), assigns(:user_friendship).friend
        end
        
        should "create a friendship" do
          assert users(:dummy_test_user_01).pending_friends.include?(users(:mikethefrog))
        end
        
        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mikethefrog))
        end
        
        
        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent.", flash[:success]
        end
      end
    end
    
  end

  context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:dummy_test_user_01), friend: @friend)
        create(:pending_user_friendship, friend: users(:dummy_test_user_01), user: @friend)
        sign_in users(:dummy_test_user_01)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user_friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the state to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end

      should "have a success flash message" do
        assert_equal "You are now friends with #{@user_friendship.friend.full_name}.", flash[:success]
      end

    end

  end

  context "#edit" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :edit, id: 1
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:dummy_test_user_01))
        sign_in users(:dummy_test_user_01)
        get :edit, id: @user_friendship.friend.profile_name
      end

      should "get edit and return success" do
        assert_response :success
      end

      should "assign to user_friendship" do
        assert assigns(:user_friendship)
      end

      should "assign to friend" do
        assert assigns(:friend)
      end
    end
  end

  context "#destroy" do
    context "when not logged in" do
      should "redirect to the login page" do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:dummy_test_user_01))
        create(:accepted_user_friendship, friend: users(:dummy_test_user_01), user: @friend)

        sign_in users(:dummy_test_user_01)
      end

      should "delete user friendships" do
        assert_difference 'UserFriendship.count', -2 do
          delete :destroy, id: @user_friendship
        end
      end

      should "set the flash message" do
        delete :destroy, id: @user_friendship
        assert_equal "Friendship destroyed.", flash[:success]
      end
    end
  end

  context "#block" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :block, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end
  end

  context "when logged in" do
    setup  do
      @user_friendship = create(:pending_user_friendship, user: users(:dummy_test_user_01))
      sign_in users(:dummy_test_user_01)
      put :block, id: @user_friendship
      @user_friendship.reload
    end

    should "assign a user friendship" do
      assert assigns(:user_friendship)
      assert_equal @user_friendship, assigns(:user_friendship)
    end

    should "update the user friendship state to blocked" do
      assert_equal 'blocked', @user_friendship.state
    end
  end
  
end
