# frozen_string_literal: true

require_relative 'solver.rb'
require_relative 'games/game_factory.rb'
require_relative 'dictionary_loader.rb'
require_relative 'ui.rb'
require_relative 'highscore_tracker.rb'
require_relative 'user_input_handler.rb'

class GameHandler
  include Ui

  # Allows access to class-level variable
  class << self; attr_accessor :current end
  @current = nil

  def initialize(dictionary)
    @solver = Solver.new(dictionary)
    GameHandler.current = self
  end

  # TODO: Shift this to a more appropriate class
  def handle_shutdown
    # TODO: Handle shutdown
  end

  def replace_dictionary(dictionary_path)
    dictionary = DictionaryLoader.make_dictionary(dictionary_path)
    @solver.replace_dictionary(dictionary)
  end

  def initialize_game(board, type, duration)
    Ui.print_formatted 'Initializing game, this may take a moment...'
    game =
      if duration.nil?
        GameFactory.create_preset_game(board, @solver, type)
      else
        GameFactory.create_custom_game(board, @solver, duration)
      end
    game
  end

  def start_game(game)
    formatted_board = format_displayed_board(game)

    await_user_confirmation_before_start(game, formatted_board)
    play_game_until_over(game, formatted_board)
    handle_game_over(game)
  end

  def await_user_confirmation_before_start(game, formatted_board)
    Ui.pause_until_next_user_input('Game generated. Press enter to begin')
    game.start

    # TODO: Display as "You have x mins and y seconds" or "You have y seconds" if x+y < 1min
    game_message = "The game has started. You have #{game.duration}s. Good luck!"

    Ui.print_formatted "#{formatted_board}#{game_message}"
  end

  def play_game_until_over(game, formatted_board)
    # TODO: How about some loop that 'ticks' every second
    loop do
      word = UserInputHandler.request_input 'Please key in your word'

      if game.game_over?
        Ui.print_formatted 'Sorry! You ran out of time'
        break
      end

      play_word(word, game)
      break if game.max_points_achieved?

      Ui.print_formatted "#{formatted_board}You have #{game.time_remaining}s left!"
    end
  end

  def play_word(word, game)
    if game.played_word?(word)
      Ui.print_formatted "Oops! Looks like you have already played #{word}"
    elsif game.valid_word?(word)
      points = game.calculate_points(word)
      game.play_word(word)
      Ui.print_formatted "Congrats! #{word} was worth #{points} point#{'s' if game.points != 1}"
    else
      Ui.print_formatted "Sorry! #{word} is not a valid word"
    end
  end

  def format_displayed_board(game)
    string_tiles = game.board_tiles
    board_size = game.board_size

    # TODO: Rebuild the board to look more impressive
    rows = string_tiles.scan(/.{#{board_size}}/)
    formatted_board = []
    rows.each do |row|
      spaced_row = row.split('').join(' ')
      formatted_board << spaced_row.to_s
    end
    formatted_board << "\n"
    formatted_board.join("\n")
  end

  def handle_game_over(game)
    if game.max_points_achieved?
      Ui.print_formatted 'Congratulations! You finished the game by scoring the maximum possible '\
                        "points: #{game.max_points}"
    else
      Ui.print_formatted "The game is now over! You scored #{game.points} "\
                      "point#{'s' if game.points != 1} in #{game.duration}s."\
                      "\nThe maximum score was: #{game.max_points} points"
    end

    handle_highscore_update(game)

    Ui.pause_until_next_user_input
    # TODO: Prompt whether want to play again
  end

  def handle_highscore_update(game)
    return unless HighscoreTracker.current.eligible_for_update?(game.type, game.points)

    Ui.print_formatted "Congratulations! You have achieved a new highscore of #{game.points} "\
                      "points for #{game.type} games.\nYour previous highscore was: "\
                      "#{HighscoreTracker.current.find_highscore(game.type)} points"
    HighscoreTracker.current.update_highscore(game.type, game.points)
  end

  def create_placeholder_games
    GameFactory.create_placeholder_games(@solver)
  end
end
