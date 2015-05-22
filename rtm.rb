require 'slack'

class RTM
  @@users = {}
  @@groups = {}
  attr_reader :url
  
  def self.setup
    resp = Slack.rtm_start
    @url = resp['url']
    resp['users'].each do |user_json|
      next if user_json['deleted']
      user = User.new(user_json)
      @@users[user.id] = user
    end
    resp['groups'].each do |group_json|
      group = Group.new(group_json)
      @@groups[group.id] = group
    end
    return self
  end

  def connect
    @ws = WebSocket::EventMachine::Client.connect(uri: @url)
    # Syntax? @ws.onmessage &:handle_message
    @ws.onmessage { |message, type| handle_message(message, type) }
    @ws.onerror { |error| handle_error(error) }
    @ws.onclose { |code, reason| handle_close(code, reason) }
    @current_id = 1
  end

  def send(message, group)
    group_id = (group.is_a? Group) ? group.id : group
    params = {
      id: @current_id,
      type: 'message',
      channel: group_id,
      text: message
    }
    @current_id += 1
    @ws.send(params.to_json)
  end

  private
  def handle_message(message, type)
    # Only handles incoming messages for now
    return unless type == 'message'
    user = @@users[message['user']]
    text = message['text']
    group = @@groups[message['channel']]
    task_id = group.name[1..-1]
    # TODO: Set the right user for Phabricator first
    Phabricator::Maniphest::Task.from_id(task_id).add_comment(text)
  end

  def handle_error(error)
  end

  def handle_close(code, reason)
  end
end
