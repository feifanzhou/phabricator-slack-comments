require 'slack'

class User
  @@cached_users = {}

  attr_reader :id, :user_name, :first_name, :last_name, :email
  def initialize(attributes)
    @id = attributes['id']
    @user_name = attributes['name']
    profile = attributes['profile']
    @first_name = profile['first_name']
    @last_name = profile['last_name']
    @email = profile['email']
  end

  def self.find_by_email(email)
    User.load_list unless @@cached_users[email]
    @@cached_users[email]
  end

  private
  def self.load_list
    resp = Slack.users_list
    resp['members'].each do |user_json|
      next if user_json['deleted']
      user = User.new(user_json)
      @@cached_users[user.email] = user
    end
  end
end
