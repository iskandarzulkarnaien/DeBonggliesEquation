# frozen_string_literal: true

class ActionHandler
  PLACEHOLDER_MESSAGE = 'This feature is not yet implemented.'

  # Allows access to class-level variable
  class << self; attr_accessor :current end
  @current = nil

  def initialize
    ActionHandler.current = self
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
