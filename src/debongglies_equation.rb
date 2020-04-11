# frozen_string_literal: true

require_relative 'ui.rb'
require_relative 'input_validator.rb'
require_relative 'highscore_tracker.rb'
require_relative 'dictionary_trie.rb'
require_relative 'game/game.rb'
require_relative 'game/game_factory.rb'

require 'tk'

# TODO: Custom board sizes
# TODO: Change all debug messages to logging messages
# TODO: Add better stats e.g. highest scoring words, how many of each word etc

# TODO: Word Based Easter Eggs
# TODO: Display easter egg message if "DEBONGE" or "DEBONGEH" was played
# TODO: "Congrats! HOTEL was worth TRIVAGO"

# TODO: Refactor class to separate components (e.g. UI/Logic)
# Linting disabled as this section has been marked for refactor
# rubocop:disable Metrics/ClassLength
class DeBoggliesEquation
  include Ui, InputValidator

  PLACEHOLDER_MESSAGE = 'This feature is not yet implemented.'

  DICTIONARY_PATH = File.join(File.dirname(__FILE__), '../data/default_dictionary.txt')

  # Linter disabled as this section should noticably spell out 'DeBongliesEquation'
  # rubocop:disable Layout/LineLength, Lint/RedundantCopDisableDirective
  WELCOME_MESSAGE = [
    '      _____       ____                          _ _             ______                  _   _                  ',
    '     |  __ \     |  _ \                        | (_)           |  ____|                | | (_)                 ',
    '     | |  | | ___| |_) | ___  _ __   __ _  __ _| |_  ___  ___  | |__   __ _ _   _  __ _| |_ _  ___  _ __       ',
    '     | |  | |/ _ \  _ < / _ \| \'_ \ / _` |/ _` | | |/ _ \/ __| |  __| / _` | | | |/ _` | __| |/ _ \| \'_ \      ',
    '     | |__| |  __/ |_) | (_) | | | | (_| | (_| | | |  __/\__ \ | |___| (_| | |_| | (_| | |_| | (_) | | | |     ',
    '     |_____/ \___|____/ \___/|_| |_|\__, |\__, |_|_|\___||___/ |______\__, |\__,_|\__,_|\__|_|\___/|_| |_|     ',
    '                                     __/ | __/ |                         | |                                   ',
    '                                    |___/ |___/                          |_|                                   '
  ].join("\n")
  # rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

  # TODO: Refactor this method by extracting constants
  # Linting disabled as this section has been marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective
  def initialize
    # Constant is declared here as it requires access to instance methods
    # TODO: Find a better way to to this
    # Stored in array for easy enumeration (i.e. when adding/removing commands, mappings do not
    # need to be manually changed)
    options_array = [
      {
        message: 'Start with a random board',
        action: -> { random_start }
      },
      {
        message: 'Start with custom board',
        action: -> { custom_start }
      },
      {
        message: 'View Highscore',
        action: -> { view_highscore }
      },
      {
        message: 'Reset Highscore',
        action: -> { reset_highscore }
      },
      {
        message: 'Import new dictionary',
        action: -> { import_dictionary }
      },
      {
        message: 'Reset to default dictionary',
        action: -> { reset_dictionary }
      },
      {
        message: 'View help',
        action: -> { help }
      },
      {
        message: 'Exit',
        action: -> { exit_program }
      }
    ]

    # TODO: Find a better way to do this
    @options = {}
    (1..options_array.size).each do |option_num|
      @options[option_num.to_s] = options_array[option_num - 1]
    end

    # TODO: Find a better way to do this
    @options_msg = ['Please select an option:']
    (1..options_array.size).each do |option_num|
      @options_msg << "#{option_num}. #{@options[option_num.to_s][:message]}"
    end
    @options_msg << 'Enter Option:'

    # TODO: Store relevant data (e.g. highscores) in json file
    @highscore_tracker = HighscoreTracker.new
    @dictionary = make_dictionary(DICTIONARY_PATH)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective

  # TODO: Refactor
  # Linting disabled as section is marked for refactor
  # rubocop:disable Metrics/MethodLength, Style/RedundantBegin
  def start
    begin
      Ui.print_formatted WELCOME_MESSAGE
      loop do
        choice = Ui.request_input @options_msg.join("\n")

        if valid_option?(choice)
          @options[choice][:action].call
        else
          Ui.print_formatted 'Invalid option selected!'
        end
      end
    rescue StandardError => e
      handle_error(e)
    end
  end
  # rubocop:enable Metrics/MethodLength, Style/RedundantBegin

  # OPTIONS METHODS

  def random_start
    game_type = request_game_type
    duration = request_duration if game_type == :custom

    game = initialize_game(nil, game_type, duration)
    start_game(game)
  end

  def custom_start
    user_board = request_user_board
    game_type = request_game_type
    duration = request_duration if game_type == :custom

    game = initialize_game(user_board, game_type, duration)
    start_game(game)
  end

  def view_highscore
    Ui.print_formatted Ui.formatted_highscore(@highscore_tracker)
    Ui.pause_until_next_user_input
  end

  def reset_highscore
    @highscore_tracker.reset_highscore
    Ui.print_formatted 'Your Highscores have all been reset to 0!'
    Ui.pause_until_next_user_input
  end

  def import_dictionary
    user_dictionary_path = Tk.getOpenFile('title' => 'Select new dictionary',
                                          'filetypes' => '{{Text} {.txt}}')
    if user_dictionary_path.empty?
      Ui.print_formatted 'Dictionary import cancelled'
    else
      @dictionary = make_dictionary(user_dictionary_path)
      Ui.print_formatted 'New dictionary successfully loaded'
    end
    Ui.pause_until_next_user_input
  end

  def reset_dictionary
    @dictionary = make_dictionary(DICTIONARY_PATH)
    Ui.print_formatted 'Default dictionary successfully loaded'
    Ui.pause_until_next_user_input
  end

  def help
    # TODO: Create help message
    Ui.print_formatted PLACEHOLDER_MESSAGE
    Ui.pause_until_next_user_input
  end

  def exit_program
    Ui.print_formatted 'Goodbye! Thanks for playing!'
    handle_shutdown
    # TODO: Remove this sleep and shift it somewhere else
    sleep(3)
    exit
  end

  # Helper Methods

  # TODO: Refactor
  # Linting has been disabled as this section is marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective
  def request_game_type
    # TODO: Refactor, do not hardcode message, have them based on actual durations of each game type
    game_types = {
      '1' => {
        type: Game::GAME_TYPES[0],
        message: 'Short Game, 2 Minutes'
      },
      '2' => {
        type: Game::GAME_TYPES[1],
        message: 'Classic Game, 3 Minutes'
      },
      '3' => {
        type: Game::GAME_TYPES[2],
        message: 'Long Game, 5 Minutes'
      },
      '4' => {
        type: Game::GAME_TYPES[3],
        message: 'Custom Game Length (Not eligible for highscore!)'
      },
      '5' => {
        type: Game::GAME_TYPES[4],
        message: 'Sandbox Game, Infinite Duration (Take as long as you like!)'
      }
    }

    game_type_msg = ['Please select a duration option:']
    game_types.keys.each { |type| game_type_msg << "#{type}. #{game_types[type][:message]}" }

    choice = nil
    loop do
      choice = Ui.request_input game_type_msg.join("\n")
      break if game_types.keys.include?(choice)

      Ui.print_formatted 'Invalid duration option selected!'
    end

    game_types[choice][:type]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective

  def request_duration
    duration = nil
    loop do
      duration = Ui.request_input 'Please enter the game\'s duration, in seconds'
      break if InputValidator.valid_duration?(duration)

      Ui.print_formatted 'Your duration is invalid!'
    end

    duration.to_i
  end

  def request_user_board
    user_board = nil
    loop do
      user_board = Ui.request_input  'Please enter a 16 Letter Board. Valid characters are A-Z and *,'\
                                  'which can be any character'
      break if InputValidator.valid_board?(user_board)

      Ui.print_formatted 'Your board contains invalid characters!'
    end
    user_board
  end

  def initialize_game(board, type, duration)
    Ui.print_formatted 'Initializing game, this may take a moment...'
    game =
      if duration.nil?
        GameFactory.create_preset_game(board, @dictionary, type)
      else
        GameFactory.create_custom_game(board, @dictionary, duration)
      end
    # Ui.print_formatted "Debug: Game with board #{game.get_board_tiles} created"
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
      word = Ui.request_input 'Please key in your word'

      if game.game_over?
        Ui.print_formatted 'Sorry! You ran out of time'
        break
      end

      word_result = play_word(word, game)

      Ui.print_formatted word_result
      Ui.print_formatted "#{formatted_board}You have #{game.time_remaining}s left!"
    end
  end

  def play_word(word, game)
    if game.played_word?(word)
      "Oops! Looks like you have already played #{word}"
    elsif game.valid_word?(word)
      points = game.calculate_points(word)
      game.play_word(word)
      "Congrats! #{word} was worth #{points} points"
    else
      "Sorry! #{word} is not a valid word"
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

  def handle_error(err)
    # TODO: Handle error. Should keep the window open until user presses any input,
    # so the error can be seen instead of window immediately close.
    raise err
  end

  def handle_shutdown
    # TODO: Handle shutdown
  end

  def handle_game_over(game)
    Ui.print_formatted "The game is now over! You scored #{game.points} "\
                    "point#{'s' if game.points > 1} in #{game.duration}s."\
                    "\nThe maximum score was: #{game.max_points} points"

    handle_highscore_update(game)

    Ui.pause_until_next_user_input
    # TODO: Prompt whether want to play again
  end

  def handle_highscore_update(game)
    return unless @highscore_tracker.eligible_for_update?(game.type, game.points)

    Ui.print_formatted "Congratulations! A new highscore of #{game.points} compared to "\
                    "#{@highscore_tracker.find_highscore(game.type)}"
    @highscore_tracker.update_highscore(game.type, game.points)
  end

  # TODO: Find a better way to do this
  def valid_option?(option)
    ('1'..@options.size.to_s).include?(option)
  end

  def make_dictionary(dictionary_path)
    dictionary = DictionaryTrie.new
    File.open(dictionary_path).each { |word| dictionary.insert(word.chomp.upcase) }
    dictionary
  end
end
# rubocop:enable Metrics/ClassLength
