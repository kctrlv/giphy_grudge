class LobbyGame
  def self.players
    REDIS.smembers("players")
  end

  def self.responses
    REDIS.hgetall("responses")
  end

  def self.add_players(players)
    REDIS.sadd('players', players.pluck(:name) )
  end

  def self.broadcast_start(players)
    names = players.map{ |p| p.first_name }.join(', ')
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_start',
      players: names
    }
  end

  def self.play_card
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_card',
      card: Card.all.sample.title
    }
  end

  def self.listen_for_replies(players)
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_listen',
    }
  end

  def self.start(players)
    add_players(players)
    broadcast_start(players)
    sleep(1)
    play_card
    listen_for_replies(players)
  end

  def self.get_reply(name, giphy)
    REDIS.hset('responses', name, giphy)
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_received_reply',
      user: name.split(' ').first
    }
    start_vote if all_replied
  end

  def self.all_replied
    (players - responses.keys).empty?
  end

  # def self.announce_locked_to_current_players
  #   ActionCable.server.broadcast 'lobby_channel', {
  #     action: 'game_locked'
  #   }
  # end
end
