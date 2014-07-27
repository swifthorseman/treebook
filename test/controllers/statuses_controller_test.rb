require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  # don't like it at all – defeats the purpose of blocking someone
  # if all they need to do is log out to view the blocked-people's post.
  # perhaps, 'block' should be renamed 'unfollow'
  test "should display users' post when not logged in" do
    users(:blocked_friend).statuses.create(content: 'blockedddd!')
    users(:mikethefrog).statuses.create(content: 'yahoo!')
    get :index
    assert_match /yahoo\!/, response.body
    assert_match /blockedddd\!/, response.body
  end

  test "should not display blocked users' post when logged in" do
    sign_in users(:dummy_test_user_01)
    users(:blocked_friend).statuses.create(content: 'blockedddd!')
    users(:mikethefrog).statuses.create(content: 'yahoo!')
    get :index
    assert_match /yahoo\!/, response.body
    assert_no_match /blockedddd\!/, response.body
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:dummy_test_user_01)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:dummy_test_user_01)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item for the status when logged in" do
    sign_in users(:dummy_test_user_01)
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content }
    end
  end

  test "should create status for the current user when logged in" do
    sign_in users(:dummy_test_user_01)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:dummy_test_user_01).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:dummy_test_user_01)
    get :edit, id: @status
    assert_response :success

  end

  test "should redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:dummy_test_user_01)

    patch :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item when the status is updated" do
    sign_in users(:dummy_test_user_01)
    assert_difference('Activity.count') do
      put :update, id: @status, status: { content: @status.content }
    end
  end

  test "should update status for the current user when logged in" do
    sign_in users(:dummy_test_user_01)

    patch :update, id: @status, status: { content: @status.content, user_id: users(:dummy_test_user_02).id }
    
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:dummy_test_user_01).id
  end
  
  test "should not update the status if nothing has changed" do
    sign_in users(:dummy_test_user_01)

    patch :update, id: @status
    
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:dummy_test_user_01).id
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
