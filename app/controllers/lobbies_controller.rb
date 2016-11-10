class LobbiesController < ApplicationController
  before_action :require_user

  def show
    @onlineUsers = REDIS.smembers('onlineUsers').map { |id| User.find_by(id: id) }.compact
    @user = current_user
  end
end
