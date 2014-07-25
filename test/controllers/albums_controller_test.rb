require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    @album = albums(:vacation)
    @user  = users(:dummy_test_user_01)
  end

  test "should get index" do
    get :index, profile_name: @user.profile_name
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  test "should get new" do
    sign_in users(:dummy_test_user_01)
    get :new, profile_name: @user.profile_name
    assert_response :success
  end

  test "should create album" do
    sign_in users(:dummy_test_user_01)    
    assert_difference('Album.count') do
      post :create, profile_name: @user.profile_name, album: { title: @album.title }
    end

    assert_redirected_to album_path(assigns(:album))
  end

  test "should show album" do
    get :show, profile_name: @user.profile_name, id: @album
    assert_response :redirect
    assert_redirected_to album_pictures_path(@user.profile_name, @album.id)
  end

  test "should get edit" do
    sign_in users(:dummy_test_user_01)
    get :edit, profile_name: @user.profile_name, id: @album
    assert_response :success
  end

  test "should update album" do
    sign_in users(:dummy_test_user_01)
    patch :update, profile_name: @user.profile_name, id: @album, album: { title: @album.title, user_id: @album.user_id }
    assert_redirected_to album_pictures_path(@user.profile_name, @album.id)
  end

  test "should destroy album" do
    sign_in users(:dummy_test_user_01)    
    assert_difference('Album.count', -1) do
      delete :destroy, profile_name: @user.profile_name, id: @album
    end

    assert_redirected_to albums_path
  end
end
