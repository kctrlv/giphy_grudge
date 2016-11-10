# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class LobbyChannel < ApplicationCable::Channel
  attr_reader :listen, :listen_for_vote

  def subscribed
    stream_from "lobby_channel"
  end

  def connected
    if !REDIS.sismember('onlineUsers', current_user.id)
      REDIS.sadd('onlineUsers', current_user.id)
      ActionCable.server.broadcast 'lobby_channel', {
        action: "userAppear",
        uid: current_user.id,
        user: current_user.first_name,
        points: current_user.points
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
    if @listen == true
      if data['message'] == '.stop'
        ActionCable.server.broadcast 'lobby_channel', {
          action: 'game_stopped',
          user: current_user.first_name
        }
        return LobbyGame.finish
      else
        game_speak(data)
      end
    else
      user_handle = current_user.avatar || current_user.first_name
      action, message = determine_action_and_message(data)
      ActionCable.server.broadcast 'lobby_channel', {
        action: action,
        message: message,
        user: user_handle,
        has_avatar: !!current_user.avatar
      }
    end
  end

  def game_speak(data)
    if LobbyGame.players.include? current_user.name
        LobbyGame.get_reply(current_user.name, GiphyService.fixed_height_translate(data['message']))
    # else
    #   LobbyGame.announce_locked_to_current_players
    end
  end

  def start_listen
    @listen = true
  end

  def listen_for_vote
    @listen_for_vote = true
  end

  def stop_listen
    @listen = false
    @listen_for_vote = false
  end

  def click_image(data)
    if @listen_for_vote
      if LobbyGame.players.include? current_user.name
        LobbyGame.get_vote(current_user.name, data['image'])
      end
    end
  end

  def determine_action_and_message(data)
    if data['message'].split.first == '.t'
      return ['text', data['message'][3..-1] || '']
    elsif data['message'] == '.r'
      return ['randomgiphy', GiphyService.random_image]
    elsif data['message'].split.first == '.?'
      return ['inform', '']
    elsif data['message'] == '.play'
      return playRound
    else
      return ['giphy', GiphyService.fixed_height_translate(data['message'])]
    end
  end

  def playRound
    return nil unless REDIS.smembers('players').empty?
    player_ids = REDIS.smembers('onlineUsers')
    players = player_ids.map { |id| User.find_by(id: id) }.compact
    LobbyGame.start(players)
  end
end
