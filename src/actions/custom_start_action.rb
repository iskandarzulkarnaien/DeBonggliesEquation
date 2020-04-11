require_relative 'action.rb'

class CustomStartAction < Action
  MESSAGE = 'Start with custom board'
  TYPE = :custom_start_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    user_board = UserInputHandler.request_user_board
    game_type = UserInputHandler.request_game_type
    duration = UserInputHandler.request_duration if game_type == :custom

    game = @game_manager.initialize_game(user_board, game_type, duration)
    @game_manager.start_game(game)
  end
end
