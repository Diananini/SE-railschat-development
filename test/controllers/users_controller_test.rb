require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # setup do
  #   @user = users(:one)
  # end
  #
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:users)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

 # test "should create user" do



  #  post :create, params: {user: { name:'diana', email:'diana@test.com', password:'1111111', sex:'female', phonenumber:'111111' }}
  #  assert_redirected_to sessions_login_path

  #  post :create, params: {user: { name:'user1', email:'user1@test.com' }}
  #  assert_equal '用户名或邮箱已被注册', flash["danger"]
  #  assert_redirected_to root_url



  # end
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
        name: 'test11111',
        email: 'test122222@test.cn',
        password: 'password',
      }
    end
    assert_redirected_to root_url

    post :create, user: {
      name: 'user1',
      email: 'user1@test.com',
      password: 'password',
    }
    assert flash['danger']=='用户名或邮箱已被注册'

    # assert_redirected_to root_url


  end

  # test "should show user" do
  #   get :show, id: @user
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @user
  #   assert_response :success
  # end
  #
  # test "should update user" do
  #   patch :update, id: @user, user: {  }
  #   assert_redirected_to user_path(assigns(:user))
  # end
  #
  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete :destroy, id: @user
  #   end
  #
  #   assert_redirected_to users_path
  # end
end
