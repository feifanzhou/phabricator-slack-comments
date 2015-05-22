require 'sinatra'
require 'slack'

get '/' do
  "Server has not crashed"
end

Slack.configure do |config|
  config.token = 'YOUR_TOKEN'
end

EM.run do
  ws = WebSocket::EventMachine::Client.connect(uri: 'uri')

  ws.onmessage do |message, type|
  end

  ws.onerror do |error|
  end

  ws.onclose do |code, reason|
  end
end
