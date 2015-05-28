require 'slack'

class Group
  @@cached_groups = {}

  attr_reader :id, :name
  def initialize(attributes)
    @id = attributes['id']
    @name = attributes['id']
  end

  def invite(user)
    options = {
      user: (user.is_a? User) ? user.id : user
    }
    Slack.groups_invite(group_options.merge(options))
    # TODO: Check response
  end

  def archive
    Slack.groups_archive(group_options)
  end

  def self.create(name)
    options = {
      name: name
    }
    resp = Slack.groups_create(options)
    group = Group.new(resp['group'])
    @@cached_groups[group.name] = group
  end

  def self.find_by_name(name)
    Group.load_list unless @@cached_groups[name]
    @@cached_groups[name]
  end

  def post(text)
    options = {
      text: text,
      username: 'PSC Bot'
    }
    Slack.chat_postMessage(group_options.merge(options))
    # TODO: Check response
  end

  private
  def self.load_list
    resp = Slack.groups_list
    # TODO: Check 'ok' field for error
    resp['groups'].each do |group_json|
      group = Group.new(group_json)
      @@cached_groups[group.name] = group
    end
  end

  def group_options
    {
      channel: self.id
    }
  end
end
