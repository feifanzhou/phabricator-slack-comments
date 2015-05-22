require 'sinatra'
require 'slack'

get '/' do
  "Server has not crashed"
end

Slack.configure do |config|
  config.token = 'YOUR_TOKEN'
end
