# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # byebug
    ActionCable.server.broadcast 'lobby_channel', {
      message: data['message'],
      user: current_user.first_name
    }
  end
end
