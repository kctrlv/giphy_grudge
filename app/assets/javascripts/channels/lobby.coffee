App.lobby = App.cable.subscriptions.create "LobbyChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "speak"
        reply = data['user'] + ': ' + '<img src="' + data['message'] + '"><br>'
        $('.messages').append(reply)
      # when "appear"
      #   reply = '<li>' + data['user'] + '</li>'
      #   $('.users-online').append(data)

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", '[data-behavior~=lobby_speaker]', (event) ->
  if event.keyCode is 13
    App.lobby.speak event.target.value
    event.target.value = ''
    event.preventDefault()
