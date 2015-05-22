require 'slack'

class RTM
  @@users_by_email = {}
  @@groups_by_name = {}
  attr_reader :url
  
  def self.setup
    resp = Slack.rtm_start
    @url = resp['url']
    resp['users'].each do |user_json|
      next if user_json['deleted']
      user = User.new(user_json)
      @@users_by_email[user.email] = user
    end
    resp['groups'].each do |group_json|
      group = Group.new(group_json)
      @@groups_by_name[group.name] = group
    end
    return self
  end
end
