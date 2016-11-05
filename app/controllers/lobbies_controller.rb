class LobbiesController < ApplicationController
  before_action :require_user

  def show
    @onlineUsers = REDIS.smembers('onlineUsers')
    @user = current_user
  end
end
