# frozen_string_literal: true

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

    game = @game_handler.initialize_game(user_board, game_type, duration)
    @game_handler.start_game(game)
  end
end
