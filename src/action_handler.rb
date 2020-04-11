class ActionHandler
  PLACEHOLDER_MESSAGE = 'This feature is not yet implemented.'
  @@current_action_handler = nil

  def initialize(args = nil)
    @@current_action_handler ||= self
    @@current_action_handler
  end

  def self.current
    @@current_action_handler || self.new
  end

  def action_message(action)
    action.message
  end

  def placeholder
    PLACEHOLDER_MESSAGE
  end

  def self.execute(action)
    action.execute
  end
end
