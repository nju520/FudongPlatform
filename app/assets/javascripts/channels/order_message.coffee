App.order_message = App.cable.subscriptions.create "OrderMessageChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    $.notify(data["message"], "success")

  notify: (message) ->
    @perform 'notify', message: message

$(document).on 'click', '#pay-to-seller-btn', (event) ->
  # console.log(event.target.data)
  App.order_message.notify event.target.data
