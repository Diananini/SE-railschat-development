class FriendshipsController < ApplicationController
  include SessionsHelper
  before_action :logged_in

  def create
    i_inverse_friend = User.find_by_id(params[:friend_id])
    if current_user.friends.include? i_inverse_friend
      if i_inverse_friend.friends.include? current_user
        flash[:info] = "你们已经是好友了"
        redirect_to chats_path
      else
        flash[:info] = "你已经邀请过了，等待回应"
        redirect_to chats_path
      end
    end

    if i_inverse_friend.friends.include? current_user
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      if @friendship.save
        flash[:info] = "添加好友成功"
        redirect_to chats_path
      else
        flash[:error] = "无法添加好友"
        redirect_to chats_path
      end
    else
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      if @friendship.save
        flash[:info] = "邀请好友成功"
        redirect_to chats_path
      else
        flash[:error] = "无法邀请好友"
        redirect_to chats_path
      end
    end
  end

  def destroy
    i_inverse_friend = User.find_by_id(params[:id])

    if current_user.friends.include? i_inverse_friend
      @friendship = current_user.friendships.find_by(friend_id: params[:id])
      @friendship.destroy
    end

    if i_inverse_friend.friends.include? current_user
      @friendship_i = i_inverse_friend.friendships.find_by(friend_id: current_user.id)
      @friendship_i.destroy
    end    

    user=User.find_by_id(params[:id])
    current_user.chats.each do |chat|
      if (chat.users-[user, current_user]).blank?
        chat.destroy
      end
    end

    flash[:success] = "删除好友成功"
    redirect_to chats_path
  end

  private
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end
end
