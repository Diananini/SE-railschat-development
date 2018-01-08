class SessionsController < ApplicationController
  include SessionsHelper

  def login
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
      flash= {:info => "欢迎回来: #{user.name} :)"}
    else
      flash= {:danger => '账号或密码错误'}
    end
    redirect_to root_url, :flash => flash
  end

  def signup
    user1 = User.find_by(name: params[:session][:name])
    user2 = User.find_by(email: params[:session][:email].downcase)
    if user1 || user2
      flash= {:danger => '用户名或邮箱已被注册'}
    else
      user_name = params[:session][:name]
      user_email = params[:session][:email].downcase
      user_pwd = params[:session][:password]
      user_ph = params[:session][:phonenumber]
      User.create(
        name: user_name,
        email: user_email, # "user#{index}@test.com",
        password: user_pwd, # 'password',
        role: Faker::Number.between(1, 4),
        sex: ['male', 'female'].sample,
        phonenumber: user_ph,
        status: Faker::Company.profession
      )
      # login this persion
      user = User.find_by(email: params[:session][:email].downcase)
      log_in user
      params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
      flash= {:info => "注册成功: #{user.name} :)"}
    end
    # User.first.friendships.create(:friend_id => 2)
    redirect_to root_url, :flash => flash
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
