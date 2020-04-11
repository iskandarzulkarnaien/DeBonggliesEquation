# frozen_string_literal: true

require_relative '../ui.rb'
require_relative '../user_input_handler.rb'

class Action
  include Ui
  include UserInputHandler

  attr_accessor :message

  def initialize(message, type)
    @message = message
    @type = type
    @highscore_tracker = HighscoreTracker.current
    @game_manager = GameManager.current_manager
    @action_handler = ActionHandler.current
  end

  def execute
    # For subclasses to implement
  end
end
