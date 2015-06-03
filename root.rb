require './lib/phabricator'
require 'sinatra'
require 'slack'
require './story'
require './group'
require 'dotenv'

Dotenv.load

Slack.configure do |config|
  config.token = ENV['SENDO_API_TOKEN']
end

p ENV['PHABRICATOR_API_TOKEN']
Phabricator.configure do |c|
  c.host = 'phabricator.sendo.me'
  c.user = 'feifan'
  c.cert = ENV['PHABRICATOR_API_TOKEN']
end

get '/' do
  "Server has not crashed"
end

post '/feed' do
  # Sample params:
  # {"storyID"=>"1080", "storyType"=>"PhabricatorApplicationTransactionFeedStory", "storyData"=>{"objectPHID"=>"PHID-TASK-mnrlfwkftziocglweygk", 
  # "transactionPHIDs"=>{"0"=>"PHID-XACT-TASK-kxhjvfopy3ehus4"}}, "storyAuthorPHID"=>"PHID-USER-c2jesh64y2qkvlq7e7uk", 
  # "storyText"=>"feifan added a comment to T113: Test task.", "epoch"=>"1432828732"}
  story = Story.new(params)
  p 'Made story'
  task = Phabricator::Maniphest::Task.find_by_id(story.task_id)
  p 'Found task'
  comment = task.comment_from_transaction(story.transaction_phid)
  p 'Posting to Slack'
  Group.find_by_name["t#{ story.task_id }"].post(comment.text)
end
