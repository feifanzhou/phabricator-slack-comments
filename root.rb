require 'sinatra'
require 'slack'

get '/' do
  "Server has not crashed"
end

post '/feed' do
  p '========================'
  p 'Post feed'
  p params
end

Slack.configure do |config|
  config.token = ENV['SENDO_API_TOKEN']
end
