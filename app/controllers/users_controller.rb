class UsersController < ApplicationController
  include SessionsHelper
  before_action :set_user, except: [:index, :new, :index_json, :create, :signup]
  before_action :logged_in, only: [:show]
  before_action :correct_user, only: [:show, :update]
  before_action :logged_out, only: [:create]

  def new
    @user=User.new
  end

  def create
    if params.include?:user
      user1 = User.find_by(name: params[:user][:name])
      user2 = User.find_by(email: params[:user][:email].downcase)
      if user1 || user2
        flash= {:danger => '用户名或邮箱已被注册'}
      else
        user_name = params[:user][:name]
        user_email = params[:user][:email].downcase
        user_pwd = params[:user][:password]
        user_ph = params[:user][:phonenumber]
        user_sex = params[:user][:sex]
        User.create(
          name: user_name,
          email: user_email, # "user#{index}@test.com",
          password: user_pwd, # 'password',
          role: Faker::Number.between(1, 4),
          sex: user_sex,
          phonenumber: user_ph,
          status: Faker::Company.profession
        )
        # login this persion
        user = User.find_by(email: params[:user][:email].downcase)
        log_in user
        params[:user][:remember_me] == '1' ? remember_user(user) : forget_user(user)
        flash= {:info => "注册成功: #{user_name} :)"}
      end
      redirect_to root_url, :flash => flash
    end
  end

  def show
    @users = User.find_by(id: params[:id])
  end


  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to user_path(current_user.id), flash: flash
  end

  def destroy
    @user.destroy
    redirect_to users_path(new: false), flash: {success: "用户删除"}
  end

  def index
    @users=User.search(params).paginate(:page => params[:page], :per_page => 10)
  end

  def index_json
    @users=User.search_friends(params, current_user)
    render json: @users.as_json
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :sex, :department_id, :password,
                                 :phonenumber, :status)
  end

# Confirms a logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def logged_out
    if logged_in?
      redirect_to chat_path, flash: {warning: '您已登录!'}
    end
  end

  def correct_user
    unless current_user == @user or current_user.role == 5
      redirect_to user_path(current_user), flash: {:danger => '您没有权限浏览他人信息'}
    end
  end

  def set_user
    @user=User.find_by_id(params[:id])
    if @user.nil?
      redirect_to root_path, flash: {:danger => '没有找到此用户'}
    end
  end

end
