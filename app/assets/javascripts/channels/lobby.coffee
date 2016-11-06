App.lobby = App.cable.subscriptions.create "LobbyChannel",
  appendGiphy: (user, message) ->
    reply = '<div class="giphy"><span class="username">' + user + '</span> ' + '<img src="' + message + '"></div><br>'
    $('.messages').append(reply)
    # $('html,body').animate({scrollTop: $(document).height()}, 1000)
    # $('.responses').animate({ scrollTop:  $('.messages:last-child').offset().top - 300 });
    $('.responses').animate({scrollTop: $('.messages').height()}, 1000)

  userAppear: (user) ->
    $ ->
      content =  '<li id="' + user + '">' + user + '</li>'
      $('.users_online').append(content)

  userDisappear: (user) ->
    $(document).ready ->
      $('#' + user).remove()

  connected: ->
    @perform 'connected'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "speak"
        App.lobby.appendGiphy(data['user'], data['message'])
      when 'userAppear'
        App.lobby.userAppear(data['user'])
      when 'userDisappear'
        App.lobby.userDisappear(data['user'])

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", '[data-behavior~=lobby_speaker]', (event) ->
  if event.keyCode is 13
    if event.target.value
      App.lobby.speak event.target.value
    event.target.value = ''
    event.preventDefault()
