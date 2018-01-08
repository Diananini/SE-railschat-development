class MessagesController < ApplicationController
  include SessionsHelper
  before_action :set_message, only: [:update, :destroy]

  def create
    @message = current_user.messages.build(message_params)
    chat=Chat.find_by_id(params[:chat_room])
    redirect_to chats_path, flash: {:warning => '此聊天不存在'} and return if chat.nil?
    @message.chat=chat

    require 'uri'
    require 'net/http'
    require 'json'
    url = URI.parse("http://api.bosonnlp.com/sentiment/analysis")
    http = Net::HTTP.new(url.host, url.port)  #new a http
    request = Net::HTTP::Post.new(url.path)
    request.initialize_http_header({'X-Token' => "_pjdTAzD.21654.Xfna6PEq5yLu"})
    sent_data = [@message.body]
    puts sent_data.to_json
    request.body = sent_data.to_json
    response = http.request(request)
    echo_message = response.body
    echo_message = echo_message[2..-3] #去掉中括号
    echo_message = echo_message.split(",")

    @message.positive = echo_message[0].to_f
    @message.negative = echo_message[1].to_f

    # echo_message = "#{echo_message[0].to_f}:#{echo_message[1].to_f}"
    if @message.save
      sync_new @message, scope: chat
    else
      redirect_to chat_path(chat), flash: {:warning => '消息发送失败'} and return
    end
    # redirect_to chat_path(chat)
  end

  # def create
  #   @message = current_user.messages.build(message_params)
  #   chat=Chat.find_by_id(params[:chat_room])
  #   redirect_to chats_path, flash: {:warning => '此聊天不存在'} and return if chat.nil?
  #   @message.chat=chat
  #   if @message.save
  #     sync_new @message, scope: chat
  #   else
  #     redirect_to chat_path(chat), flash: {:warning => '消息发送失败'} and return
  #   end
  #   redirect_to chat_path(chat)
  # end


  def destroy
    @message = Message.find(params[:id])
    chat=Chat.find_by_id(params[:chat_room])
    @message.destroy
    sync_destroy @message
    redirect_to chat_path(chat)
  end

  def destroyall
    chat=Chat.find_by_id(params[:chat_room])
    chat.messages.delete_all
    redirect_to chat_path(chat), flash: {info: '聊天记录已清空'}
  end

  private
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end

# def update
#   respond_to do |format|
#     if @message.update(message_params)
#       format.html { redirect_to @message, notice: 'Message was successfully updated.' }
#       format.json { render :show, status: :ok, location: @message }
#     else
#       format.html { render :edit }
#       format.json { render json: @message.errors, status: :unprocessable_entity }
#     end
#   end
# end
