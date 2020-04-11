# frozen_string_literal: true

class ActionHandler
  PLACEHOLDER_MESSAGE = 'This feature is not yet implemented.'
  @current_action_handler = nil

  def initialize
    @current_action_handler = self
  end

  def self.current
    @current_action_handler || new
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
