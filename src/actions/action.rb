require_relative '../ui.rb'
require_relative '../user_input_handler.rb'

class Action
  include Ui, UserInputHandler

  attr_accessor :message

  # Params are provided by subclasses
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
