# frozen_string_literal: true

require_relative 'dictionary_trie.rb'
require_relative 'game/game.rb'
require_relative 'game/game_factory.rb'
require_relative 'game/classic_game.rb'
require_relative 'game/short_game.rb'
require_relative 'game/long_game.rb'
require_relative 'game/custom_game.rb'
require_relative 'game/sandbox_game.rb'
require_relative 'highscore/highscores.rb'

require 'tk'

# TODO: Custom board sizes
# TODO: Change all debug messages to logging messages
# TODO: Add better stats e.g. highest scoring words, how many of each word etc

# TODO: Word Based Easter Eggs
# TODO: Display easter egg message if "DEBONGE" or "DEBONGEH" was played
# TODO: "Congrats! HOTEL was worth TRIVAGO"

# TODO: Remove placeholder message

# TODO: Refactor class to separate components (e.g. UI/Logic)
# Linting disabled as this section has been marked for refactor
# rubocop:disable Metrics/ClassLength
class DeBoggliesEquation
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

    # TODO: Store the below in json file
    # debug_hash = { short: 1, classic: 2, long: 3, custom: 4, sandbox:5 }
    # @highscore = Highscore.new(*debug_hash.values)
    @highscore = Highscore.new
    puts @highscore.inspect

    @dictionary = make_dictionary(DICTIONARY_PATH)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective

  # TODO: Refactor
  # Linting disabled as section is marked for refactor
  # rubocop:disable Metrics/MethodLength, Style/RedundantBegin
  def start
    begin
      print_formatted WELCOME_MESSAGE
      loop do
        choice = request_input @options_msg.join("\n")

        if valid_option?(choice)
          @options[choice][:action].call
        else
          print_formatted 'Invalid option selected!' unless @options.keys.include?(choice)
        end
      end
    rescue StandardError => e
      handle_error(e)
    end
  end
  # rubocop:enable Metrics/MethodLength, Style/RedundantBegin

  def random_start
    game_type = request_game_type
    duration = request_duration if game_type == :custom

    game = initialize_game(nil, game_type, duration)
    start_playing(game)
  end

  def custom_start
    user_board = request_user_board
    game_type = request_game_type
    duration = request_duration if game_type == :custom

    game = initialize_game(user_board, game_type, duration)
    start_playing(game)
  end

  def view_highscore
    print_formatted formatted_highscore
    pause_until_next_user_input
  end

  def reset_highscore
    @highscore.reset_highscore
    print_formatted 'Your Highscores have all been reset to 0!'
    pause_until_next_user_input
  end

  # Linting disabled as this section can cause I/O issues
  # rubocop:disable Style/RedundantBegin, Metrics/MethodLength
  def import_dictionary
    begin
      user_dictionary_path = Tk.getOpenFile('title' => 'Select new dictionary',
                                            'filetypes' => '{{Text} {.txt}}')
      if user_dictionary_path.empty?
        print_formatted 'Dictionary import cancelled'
      else
        @dictionary = make_dictionary(user_dictionary_path)
        print_formatted 'New dictionary successfully loaded'
      end
      pause_until_next_user_input
    rescue StandardError => e
      raise 'Dictionary Import Failed! Please send a screenshot of this error '\
            "to the developer\n#{e.message}"
    end
  end
  # rubocop:enable Style/RedundantBegin, Metrics/MethodLength

  def reset_dictionary
    @dictionary = make_dictionary(DICTIONARY_PATH)
    print_formatted 'Default dictionary successfully loaded'
    pause_until_next_user_input
  end

  def help
    # TODO: Create help message
    print_formatted PLACEHOLDER_MESSAGE
    pause_until_next_user_input
  end

  def exit_program
    print_formatted 'Goodbye! Thanks for playing!'
    handle_shutdown
    # TODO: Remove this sleep and shift it somewhere else
    sleep(3)
    exit
  end

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
      choice = request_input game_type_msg.join("\n")
      break if game_types.keys.include?(choice)

      print_formatted 'Invalid duration option selected!'
    end

    game_types[choice][:type]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective

  def request_duration
    duration = nil
    loop do
      duration = request_input 'Please enter the game\'s duration, in seconds'
      break if valid_duration?(duration)

      print_formatted 'Your duration is invalid!'
    end

    duration.to_i
  end

  def request_user_board
    user_board = nil
    loop do
      user_board = request_input  'Please enter a 16 Letter Board. Valid characters are A-Z and *,'\
                                  'which can be any character'
      break if valid_board?(user_board)

      print_formatted 'Your board contains invalid characters!'
    end
    user_board
  end

  def initialize_game(board, type, duration)
    print_formatted 'Initializing game, this may take a moment...'
    game =
      if duration.nil?
        GameFactory.create_preset_game(board, @dictionary, type)
      else
        GameFactory.create_custom_game(board, @dictionary, duration)
      end
    # print_formatted "Debug: Game with board #{game.get_board_tiles} created"
    game
  end

  # TODO: Refactor
  # Linting disabled as this section has been marked for refactor
  # rubocop:disable Netrics/AbcSize, Metrics/MethodLength
  def start_playing(game)
    # print_formatted 'Debug: start_playing run'
    pause_until_next_user_input('Game generated. Press enter to begin')
    game.start

    formatted_board = format_displayed_board(game)
    # TODO: Display as "You have x mins and y seconds" or "You have y seconds" if x+y < 1min
    game_message = "The game has started. You have #{game.duration}s. Good luck!"

    print_formatted "#{formatted_board}#{game_message}"

    # TODO: How about some loop that 'ticks' every second
    loop do
      word = request_input 'Please key in your word'

      if game.game_over?
        print_formatted 'Sorry! You ran out of time'
        break
      end

      # TODO: Refactor by extract method
      if game.played_word?(word)
        print_formatted "Oops! Looks like you have already played #{word}"
      elsif game.valid_word?(word)
        points = game.calculate_points(word)
        game.play_word(word)
        game.increment_points(points)
        print_formatted "Congrats! #{word} was worth #{points} points"
      else
        print_formatted "Sorry! #{word} is not a valid word"
      end
      print_formatted "#{formatted_board}You have #{game.time_remaining}s left!"
    end
    handle_game_over(game)
  end
  # rubocop:enable Netrics/AbcSize, Metrics/MethodLength

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
    print_formatted "The game is now over! You scored #{game.points} points in "\
                    "#{game.duration}s.\nThe maximum score was: #{game.max_points} points"

    if eligible_for_new_highscore(game)
      print_formatted "Congratulations! A new highscore of #{game.points} compared to "\
                      "#{@highscore[game.type]}"
      @highscore = game.points
    end
    pause_until_next_user_input
    # TODO: Prompt whether want to play again
  end

  def valid_duration?(duration)
    # TODO: This looks hacky, find a better way to check if integer
    # Linting suppressed as this line has been marked for refactor
    # rubocop:disable Style/RescueModifier, Lint/RedundantCopDisableDirective
    Integer(duration) rescue false
    # rubocop:enable Style/RescueModifier, Lint/RedundantCopDisableDirective
  end

  def valid_board?(board)
    # print_formatted "Debug: valid_board? run"
    # TODO: Remove hardcoded value
    board.length == 16 && !board.match(/[^A-Z*]/)
  end

  # TODO: Find a better way to do this
  def valid_option?(option)
    ('1'..@options.size.to_s).include?(option)
  end

  def print_formatted(message)
    sleep(0.1) # Instantaenous output is hard to follow and may seem too overwhelming for some users
    puts "\n#{message}\n"
  end

  def request_input(message)
    print_formatted message
    print '>>> '
    gets.chomp.strip.upcase
  end

  def make_dictionary(dictionary_path)
    dictionary = DictionaryTrie.new
    File.open(dictionary_path).each { |word| dictionary.insert(word.chomp.upcase) }
    dictionary
  end

  def pause_until_next_user_input(message = 'Press enter to continue...')
    print_formatted message
    gets
  end

  def eligible_for_new_highscore(game)
    !game.custom_game? && game.points > @highscore[game.type]
  end

  def formatted_highscore
    "Your Highscores are:\n#{@highscore.to_s}"
  end
end
# rubocop:enable Metrics/ClassLength
