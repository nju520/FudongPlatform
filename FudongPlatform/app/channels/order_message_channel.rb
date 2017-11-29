class OrderMessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user}"
  end

  def unsubscribed
  end

  def notify(data)
    # ActionCable.server.broadcast 'order_message_channel', message: (data["message"])
  end
end
