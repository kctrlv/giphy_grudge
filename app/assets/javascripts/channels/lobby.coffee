App.lobby = App.cable.subscriptions.create "LobbyChannel",
  append: (html) ->
    $('.messages').append(html)
    $('.responses').animate({scrollTop: $('.messages').height()}, 1000)

  appendGiphy: (user, message, has_avatar) ->
    if has_avatar
      html = '<div class="giphy"><img class="avatar-img" src="' + user + '"><img class="giphy-img" src="' + message + '"></div>'
    else
      html = '<div class="giphy"><span class="username">' + user + '</span> ' + '<img class="giphy-img" src="' + message + '"></div>'
    App.lobby.append(html)

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

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", '[data-behavior~=lobby_speaker]', (event) ->
  if event.keyCode is 13
    if event.target.value
      App.lobby.speak event.target.value
    event.target.value = ''
    event.preventDefault()
