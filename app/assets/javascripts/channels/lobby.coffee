App.lobby = App.cable.subscriptions.create "LobbyChannel",
  appendGiphy: (user, message, has_avatar) ->
    if has_avatar
      reply = '<div class="giphy"><img class="avatar-img" src="' + user + '"><img class="giphy-img" src="' + message + '"></div><br>'
    else
      reply = '<div class="giphy"><span class="username">' + user + '</span> ' + '<img class="giphy-img" src="' + message + '"></div><br>'
    $('.messages').append(reply)
    # $('html,body').animate({scrollTop: $(document).height()}, 1000)
    # $('.responses').animate({ scrollTop:  $('.messages:last-child').offset().top - 300 });
    $('.responses').animate({scrollTop: $('.messages').height()}, 1000)

  userAppear: (user, uid) ->
    $ ->
      content =  '<li id="' + uid + '">' + user + '</li>'
      $('.users_online').append(content)

  userDisappear: (user, uid) ->
    $(document).ready ->
      $('#' + uid).remove()

  connected: ->
    @perform 'connected'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "speak"
        App.lobby.appendGiphy(data['user'], data['message'], data['has_avatar'])
      when 'userAppear'
        App.lobby.userAppear(data['user'], data['uid'])
      when 'userDisappear'
        App.lobby.userDisappear(data['user'], data['uid'])

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", '[data-behavior~=lobby_speaker]', (event) ->
  if event.keyCode is 13
    if event.target.value
      App.lobby.speak event.target.value
    event.target.value = ''
    event.preventDefault()
