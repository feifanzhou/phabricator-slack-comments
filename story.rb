class Story
  attr_reader :type, :task_id, :transaction_phid
  def initialize(params)
    @id = params['storyID']
    @type = params['storyType']
    @epoch = params['epoch']
    @transaction_phid = params['storyData']['transactionPHIDs']['0']
    @user_phid = params['storyAuthorPHID']
    @story_text = params['storyText']
    @task_id = get_task_id
  end

  def date_created
    Time.at(@epoch.to_i).to_datetime
  end

  def user
    Phabricator::User.find_by_phid(@user_phid)
  end

  private
  def get_task_id
    return '' if @story_text.nil? || @story_text.length == 0
    # Match format Tdd..., excluding colon
    # Don't want to return the T
    @story_text[/T\d{2,}/][1..-1]
  end
end