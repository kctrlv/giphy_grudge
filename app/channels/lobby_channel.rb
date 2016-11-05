# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"
    REDIS.sadd('onlineUsers', current_user.first_name)
    ActionCable.server.broadcast 'lobby_channel', {
      action: "userAppear",
      user: current_user.first_name
    }
  end

  def unsubscribed
    REDIS.srem('onlineUsers', current_user.first_name)
    ActionCable.server.broadcast 'lobby_channel', {
      action: "userDisappear",
      user: current_user.first_name
    }
  end

  def speak(data)
    ActionCable.server.broadcast 'lobby_channel', {
      action: "speak",
      message: GiphyService.fixed_height_translate(data['message']),
      user: current_user.first_name
    }
  end
end
