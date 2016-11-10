class LobbyGame
  def self.finish
    REDIS.del 'responses'
    REDIS.del 'players'
    REDIS.del 'votes'
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_stop_listen',
    }
  end

  def self.players
    REDIS.smembers("players")
  end

  def self.responses
    REDIS.hgetall("responses")
  end

  def self.votes
    REDIS.hgetall('votes')
  end

  def self.all_replied
    (players - responses.keys).empty?
  end

  def self.all_voted
    (players - votes.keys).empty?
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
    # start_vote if all_replied
    start_vote if all_replied
  end


  def self.start_vote
    ActionCable.server.broadcast 'lobby_channel', {
      action: 'game_start_vote',
      candidates: responses.values
    }
  end

  def self.voted_for_self(name, vote)
    responses[name] == vote
  end

  def self.get_vote(name, vote)
    if voted_for_self(name, vote)
      ActionCable.server.broadcast 'lobby_channel', {
        action: 'game_received_self_vote',
        user: name.split(' ').first
      }
    else
      REDIS.hset('votes', name, vote)
      ActionCable.server.broadcast 'lobby_channel', {
        action: 'game_received_vote',
        user: name.split(' ').first
      }
      finish_game if all_voted
    end
  end

  def self.finish_game
    votes = REDIS.hgetall 'votes'
    votes = votes.values
    max_votes = votes.group_by{ |x| votes.count(x) }.max
    if max_votes.first != max_votes.last.count
      # There is a draw
      ActionCable.server.broadcast 'lobby_channel', {
        action: 'game_draw',
      }
    else
      # Winner
      winning_image = max_votes.last.last
      winner = responses.select{ |k,v| v == winning_image }.first.first
      ActionCable.server.broadcast 'lobby_channel', {
        action: 'game_winner',
        user: winner.split(' ').first,
        votes: max_votes.first,
        image: winning_image
      }
    end
    finish
  end

  # def self.announce_locked_to_current_players
  #   ActionCable.server.broadcast 'lobby_channel', {
  #     action: 'game_locked'
  #   }
  # end
end
