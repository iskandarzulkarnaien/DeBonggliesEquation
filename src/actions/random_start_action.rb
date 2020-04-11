# frozen_string_literal: true

require_relative 'action.rb'

class RandomStartAction < Action
  MESSAGE = 'Start with a random board'
  TYPE = :random_start

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    game_type = UserInputHandler.request_game_type(@game_handler)
    duration = UserInputHandler.request_duration if game_type == :custom

    game = @game_handler.initialize_game(nil, game_type, duration)
    @game_handler.start_game(game)
  end
end
