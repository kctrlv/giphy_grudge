App.lobby = App.cable.subscriptions.create "LobbyChannel",


  append: (html) ->
    $('.messages').append(html)
    $('.responses').animate({scrollTop: $('.messages').height()}, 1000)

  clear: ->
    $('.messages').empty()

  appendGiphy: (user, message, has_avatar) ->
    if has_avatar
      html = '<div class="giphy"><img class="avatar-img" src="' + user + '"><img class="giphy-img" src="' + message + '"></div>'
    else
      html = '<div class="giphy"><span class="username">' + user + '</span> ' + '<img class="giphy-img" src="' + message + '"></div>'
    App.lobby.append(html)

  shuffle: (source) ->
    # Coffeescript-cookbook
    return source unless source.length >= 2
    for index in [source.length-1..1]
      randomIndex = Math.floor Math.random() * (index + 1)
      [source[index], source[randomIndex]] = [source[randomIndex], source[index]]
    source

  gameStartVote: (candidates) ->
    App.lobby.clear()
    html = '''
    <div class='inform'>
      Everyone has submitted a reply. Please click your favorite one
    </div>
    '''
    App.lobby.append(html)
    App.lobby.appendGiphy(i, message, false) for message, i in App.lobby.shuffle(candidates)
    @perform 'listen_for_vote'


  appendRandomGiphy: (user, message, has_avatar) ->
    if has_avatar
      html = '<div class="giphy"><img class="avatar-img" src="' + user + '"><img class="random-giphy" src="' + message + '"></div>'
    else
      html = '<div class="giphy"><span class="username">' + user + '</span> ' + '<img class="random-giphy" src="' + message + '"></div>'
    App.lobby.append(html)


  appendText: (user, message, has_avatar) ->
    if has_avatar
      html = '<div class="giphy"><img class="avatar-img" src="' + user + '"><span class="user-text">' + message + '</span></div>'
    else
      html = '<div class="giphy"><span class="username">' + user + '</span> ' + '<span class="user-text">' + message + '</span></div>'
    App.lobby.append(html)

  informCommands: ->
    html = '''
        <table class='inform'>
          <tr>
            <td>.?</td>
            <td>Display available commands</td>
          </tr>
          <tr>
            <td>.t</td>
            <td>Prepend message to type clear text</td>
          </tr>
          <tr>
            <td>.r</td>
            <td>Post random giphy</td>
          </tr>
          <tr>
            <td>.play</td>
            <td>Play a round of giphygrudge</td>
          </tr>
          <tr>
            <td>.stop</td>
            <td>Stops the current round</td>
          </tr>
        </table>
    '''
    App.lobby.append(html)

  announceUserOnline: (user) ->
    App.lobby.append('<div class="announce">' + user + ' has joined </div>')

  announceUserOffline: (user) ->
    App.lobby.append('<div class="announce">' + user + ' has left </div>')

  userAppear: (user, uid) ->
    $ ->
      content =  '<li id="' + uid + '">' + user + '</li>'
      $('.users_online').append(content)
      App.lobby.announceUserOnline(user)

  userDisappear: (user, uid) ->
    $(document).ready ->
      $('#' + uid).remove()
      App.lobby.announceUserOffline(user)

  connected: ->
    @perform 'connected'

  disconnected: ->

  gameStart: (players) ->
    App.lobby.clear()
    html = '''
    <div class='inform'>
      A new round is about to begin with the following players: <br>'''+
      players + '''
    </div>
    '''
    App.lobby.append(html)

  gameStopped: (user) ->
    App.lobby.clear()
    html = '''
    <div class='inform'>
      The game has been stopped by'''+
      user + '''
    </div>
    '''
    App.lobby.append(html)

  gameCard: (card) ->
    html = '''
    <div class='card'>''' +
      card + '''
    </div>
    '''
    App.lobby.append(html)

  gameListen: ->
    @perform 'start_listen'

  gameStopListen: ->
    @perform 'stop_listen'

  gameReceivedReply: (user) ->
    App.lobby.append('<div class="announce">' + user + ' has left a reply.</div>')

  gameReceivedVote: (user) ->
    App.lobby.append('<div class="announce">' + user + ' has left a vote. Only the last vote is counted.</div>')

  gameReceivedSelfVote: (user) ->
    App.lobby.append('<div class="announce">' + user + ' tried to vote for their own image. Please try again. </div>')

  gameDraw: ->
    App.lobby.clear()
    html = '''
    <div class='inform'>
      The game is a draw! Please try again.
    </div>
    '''
    App.lobby.append(html)


  gameWinner: (user, votes, image) ->
    App.lobby.clear()
    html = '''
    <div class='inform'>
      The winner is ''' + user + ''' with ''' + votes + ''' votes!
    </div>
    '''
    App.lobby.append(html)
    App.lobby.appendGiphy('---', image, false)

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "giphy"
        App.lobby.appendGiphy(data['user'], data['message'], data['has_avatar'])
      when 'randomgiphy'
        App.lobby.appendRandomGiphy(data['user'], data['message'], data['has_avatar'])
      when "text"
        App.lobby.appendText(data['user'], data['message'], data['has_avatar'])
      when 'userAppear'
        App.lobby.userAppear(data['user'], data['uid'])
      when 'userDisappear'
        App.lobby.userDisappear(data['user'], data['uid'])
      when 'inform'
        App.lobby.informCommands()
      when 'game_start'
        App.lobby.gameStart(data['players'])
      when 'game_card'
        App.lobby.gameCard(data['card'])
      when 'game_listen'
        App.lobby.gameListen()
      when 'game_stopped'
        App.lobby.gameStopped(data['user'])
      when 'game_stop_listen'
        App.lobby.gameStopListen()
      when 'game_received_reply'
        App.lobby.gameReceivedReply(data['user'])
      when 'game_start_vote'
        App.lobby.gameStartVote(data['candidates'])
      when 'game_received_vote'
        App.lobby.gameReceivedVote(data['user'])
      when 'game_received_self_vote'
        App.lobby.gameReceivedSelfVote(data['user'])
      when 'game_draw'
        App.lobby.gameDraw()
      when 'game_winner'
        App.lobby.gameWinner(data['user'], data['votes'], data['image'])

  speak: (message) ->
    @perform 'speak', message: message

  click_image: (image) ->
    @perform 'click_image', image: image

$(document).on "keypress", '[data-behavior~=lobby_speaker]', (event) ->
  if event.keyCode is 13
    if event.target.value
      App.lobby.speak event.target.value
    event.target.value = ''
    event.preventDefault()

$(document).on "click", '.giphy-img', ->
  App.lobby.click_image $(this).attr('src')



# $('.giphy-img').click ->
#   App.lobby.click_image $(this).attr('src')

# $ ->
#   $('img').click ->
#     alert 'You Clicked Me'
# $('body').on('click','img',function(){alert('it works');})
