# frozen_string_literal: true

require_relative 'dictionary_trie.rb'
require_relative 'game.rb'

require 'tk'

# Todo: Custom board sizes
# Todo: Change all debug messages to logging messages
# Todo: Add better stats e.g. highest scoring words, how many of each word etc
# Todo: Test whether OCRA can generate executable. If cannot, write script to smush everything into one file and run OCRA.

# Todo: Word Based Easter Eggs
  # Todo: Display easter egg message if "DEBONGE" or "DEBONGEH" was played
  # Todo: "Congrats! HOTEL was worth TRIVAGO"

# Todo: Remove placeholder message

class DeBoggliesEquation
  PLACEHOLDER_MESSAGE = "This feature is not yet implemented."

  DICTIONARY_PATH = File.join(File.dirname(__FILE__), "../data/default_dictionary.txt")

  WELCOME_MESSAGE = [
    "      _____       ____                          _ _             ______                  _   _                  ",
    "     |  __ \\     |  _ \\                        | (_)           |  ____|                | | (_)                 ",
    "     | |  | | ___| |_) | ___  _ __   __ _  __ _| |_  ___  ___  | |__   __ _ _   _  __ _| |_ _  ___  _ __       ",
    "     | |  | |/ _ \\  _ < / _ \\| '_ \\ / _` |/ _` | | |/ _ \\/ __| |  __| / _` | | | |/ _` | __| |/ _ \\| '_ \\      ",
    "     | |__| |  __/ |_) | (_) | | | | (_| | (_| | | |  __/\\__ \\ | |___| (_| | |_| | (_| | |_| | (_) | | | |     ",
    "     |_____/ \\___|____/ \\___/|_| |_|\\__, |\\__, |_|_|\\___||___/ |______\\__, |\\__,_|\\__,_|\\__|_|\\___/|_| |_|     ",
    "                                     __/ | __/ |                         | |                                   ",
    "                                    |___/ |___/                          |_|                                   "
  ].join("\n")

  # Todo: Find a better way to do this
  # Stored in array for easy enumeration (i.e. when adding/removing commands, mappings do not need to be manually changed)

  def initialize
    # Constant is declared here as it requires access to instance methods
    # Todo: Find a better way to to this
    options_array = [
      {
        :message => "Start with a random board",
        :action => -> { random_start }
      },
      {
        :message => "Start with custom board",
        :action => -> { custom_start }
      },
      {
        :message => "View Highscore",
        :action => -> { view_highscore }
      },
      {
        :message => "Reset Highscore",
        :action => -> { reset_highscore }
      },
      {
        :message => "Import new dictionary",
        :action => -> { import_dictionary }
      },
      {
        :message => "Reset to default dictionary",
        :action => -> { reset_dictionary }
      },
      {
        :message => "View help",
        :action => -> { help }
      },
      {
        :message => "Exit",
        :action => -> { exit_program }
      }
    ]

    # Todo: Find a better way to do this
    @options = Hash.new
    (1..options_array.size).each {|option_num| @options[option_num.to_s] = options_array[option_num - 1] }

    # Todo: Find a better way to do this
    @options_msg = ["Please select an option:"]
    (1..options_array.size).each { |option_num| @options_msg << "#{option_num}. #{@options[option_num.to_s][:message]}" }
    @options_msg << "Enter Option:"

    # Todo: Store the below in json file
    @highscore = 0
    @dictionary = make_dictionary(DICTIONARY_PATH)
  end

  def start
    begin
      print_formatted WELCOME_MESSAGE
      while true
        choice = request_input @options_msg.join("\n")

        if is_valid_option?(choice)
          @options[choice][:action].()
        else
          print_formatted "Invalid option selected!" unless @options.keys.include?(choice)
        end
      end
    rescue StandardError => e
      handle_error(e)
    end
  end

  def random_start
    duration = get_duration

    game = initialize_game(nil, duration)
    start_playing(game)
  end

  def custom_start
    user_board = get_user_board
    duration = get_duration

    game = initialize_game(user_board, duration)
    start_playing(game)
  end

  def view_highscore
    print_formatted "Your Highscore is #{@highscore}!"
  end

  def reset_highscore
    @highscore = 0
    print_formatted "Your Highscore has been reset to 0!"
  end

  def import_dictionary
    begin
      user_dictionary_path = Tk.getOpenFile('title' => "Select new dictionary", 'filetypes' => "{{Text} {.txt}}")
      if user_dictionary_path.empty?
        print_formatted "Dictionary import cancelled"
      else
        @dictionary = make_dictionary(user_dictionary_path)
        print_formatted "New dictionary successfully loaded"
      end
    rescue StandardError => e
      raise StandardError.new("Dictionary Import Failed! Please send a screenshot of this error to the developer\n" + e.message)
    end
  end

  def reset_dictionary
    @dictionary = make_dictionary(DICTIONARY_PATH)
    print_formatted "Default dictionary successfully loaded"
  end

  def help
    # Todo: Create help message
    print_formatted PLACEHOLDER_MESSAGE
  end

  def exit_program
    print_formatted "Goodbye! Thanks for playing!"
    handle_shutdown
    # Todo: Remove this sleep and shift it somewhere else
    sleep(3)
    exit
  end

  def get_duration
    while true
      duration = request_input "Please enter the game's duration, in seconds"
      break if is_valid_duration?(duration)
      print_formatted "Your duration is invalid!"
    end
    duration.to_i
  end

  def get_user_board
    while true
      user_board = request_input "Please enter a 16 Letter Board. Valid characters are A-Z and *, which can be any character"
      break if is_valid_board?(user_board)
      print_formatted "Your board contains invalid characters!"
    end
    user_board
  end

  def initialize_game(board, duration)
    print_formatted "Initializing game, this may take a moment..."
    game = Game.new(board, duration, @dictionary)
    # print_formatted "Debug: Game with board #{game.get_board_tiles} created"
    game
  end

  def start_playing(game)
    # print_formatted "Debug: start_playing run"

    formatted_board = format_2D_board(game)
    game_message = "The game has started. You have #{game.duration}s. Good luck!"

    print_formatted (formatted_board + game_message) 

    # Todo: How about some loop that 'ticks' every second
    while true
      word = request_input "Please key in your word"

      if game.is_game_over?
        print_formatted "Sorry! You ran out of time"
        break
      end

      # Todo: Refactor by extract method
      if game.is_played_word?(word)
        print_formatted "Oops! Looks like you have already played #{word}"
      elsif game.is_valid_word?(word)
        points = game.calculate_points(word)
        game.play_word(word)
        game.increment_points(points)
        print_formatted "Congrats! #{word} was worth #{points} points"
      else
        print_formatted "Sorry! #{word} is not a valid word"
      end
      print_formatted "#{formatted_board}You have #{game.get_time_remaining}s left!"
    end
    handle_game_over(game)
  end

  def format_2D_board(game)
    string_tiles = game.get_board_tiles
    board_size = game.get_board_size

    # Todo: Rebuild the board to look more impressive
    rows = string_tiles.scan(/.{#{board_size}}/)
    formatted_board = ""
    rows.each do |row|
      spaced_row = row.split('').join(' ')
      formatted_board += "#{spaced_row}\n"
    end
    formatted_board
  end

  def handle_error(e)
    #Todo: Handle error. Should keep the window open until user presses any input, so the error can be seen instead of window immediately close.
    raise e
  end

  def handle_shutdown
    #Todo: Handle shutdown
  end

  def handle_game_over(game)
    print_formatted "The game is now over! You scored #{game.points} points in #{game.duration}s"

    if game.points > @highscore
      print_formatted "Coongratulations! A new highscore of #{game.points} compared to #{@highscore}"
      @highscore = game.points
    end
    # Todo: Prompt whether want to play again
  end

  def is_valid_duration?(duration)
    # Todo: This looks hacky, find a better way to check if integer
    Integer(duration) rescue false
  end

  def is_valid_board?(board)
    # print_formatted "Debug: is_valid_board? run"
    # Todo: Remove hardcoded value
    board.length == 16 && !board.match(/[^A-Z*]/)
  end

  # Todo: Find a better way to do this
  def is_valid_option?(option)
    ("1"..@options.size.to_s).include?(option)
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
end

DeBoggliesEquation.new.start
