# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"
  end

  def connected
    if !REDIS.sismember('onlineUsers', current_user.id)
      REDIS.sadd('onlineUsers', current_user.id)
      ActionCable.server.broadcast 'lobby_channel', {
        action: "userAppear",
        uid: current_user.id,
        user: current_user.first_name
      }
    else
      REDIS.incr("ghost#{current_user.id}")
    end
  end

  def unsubscribed
    if REDIS.get("ghost#{current_user.id}").to_i > 0
      REDIS.decr("ghost#{current_user.id}")
    else
      REDIS.srem('onlineUsers', current_user.id)
      ActionCable.server.broadcast 'lobby_channel', {
        action: "userDisappear",
        uid: current_user.id,
        user: current_user.first_name
      }
    end
  end

  def speak(data)
    user_handle = current_user.avatar || current_user.first_name
    action, message = determine_action_and_message(data)
    ActionCable.server.broadcast 'lobby_channel', {
      action: action,
      message: message,
      user: user_handle,
      has_avatar: !!current_user.avatar
    }
  end

  def determine_action_and_message(data)
    if data['message'].split.first == '.t'
      return ['text', data['message'][3..-1] || '']
    elsif data['message'].split.first == '.r'
      return ['randomgiphy', GiphyService.random_image]
    elsif data['message'].split.first == '.?'
      return ['inform', '']
    else
      return ['giphy', GiphyService.fixed_height_translate(data['message'])]
    end
  end
end
