require 'sinatra'
require 'slack'
Dir[File.join(__dir__, '*.rb')].each { |file| require file }

get '/' do
  "Server has not crashed"
end

post '/feed' do
  # Sample params:
  # {"storyID"=>"1080", "storyType"=>"PhabricatorApplicationTransactionFeedStory", "storyData"=>{"objectPHID"=>"PHID-TASK-mnrlfwkftziocglweygk", 
  # "transactionPHIDs"=>{"0"=>"PHID-XACT-TASK-kxhjvfopy3ehus4"}}, "storyAuthorPHID"=>"PHID-USER-c2jesh64y2qkvlq7e7uk", 
  # "storyText"=>"feifan added a comment to T113: Test task.", "epoch"=>"1432828732"}
  story = Story.new(params)
  task = Phabricator::Maniphest::Task.from_id(story.task_id)
  comment = task.comment_from_transaction(story.transaction_phid)
  Group.find_by_name["T#{ story.task_id }"].post(comment.text)
end

Slack.configure do |config|
  config.token = ENV['SENDO_API_TOKEN']
end
