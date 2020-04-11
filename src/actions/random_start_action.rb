require_relative 'action.rb'

class RandomStartAction < Action
  MESSAGE = 'Start with a random board'
  TYPE = :random_start

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    game_type = UserInputHandler.request_game_type
    duration = UserInputHandler.request_duration if game_type == :custom

    game = @game_manager.initialize_game(nil, game_type, duration)
    @game_manager.start_game(game)
  end
end
