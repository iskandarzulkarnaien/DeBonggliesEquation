require_relative 'game.rb'
require_relative 'dictionary_trie.rb'

# Todo: Custom board sizes
# Todo: Change all debug messages to logging messages
# Todo: Add better stats e.g. highest scoring words, how many of each word etc
# Todo: Test whether OCRA can generate executable. If cannot, write script to smush everything into one file and run OCRA.

# Todo: Remove placeholder message
PLACEHOLDER_MESSAGE = "This feature is not yet implemented."

class DeBoggliesEquation
  def initialize
    @welcome_msg = '' +
      ' _____       ____                          _             ______                  _   _             ' + "\n" +
      '|  __ \     |  _ \                        | |           |  ____|                | | (_)            ' + "\n" +
      '| |  | | ___| |_) | ___  _ __   __ _  __ _| | ___  ___  | |__   __ _ _   _  __ _| |_ _  ___  _ __  ' + "\n" +
      '| |  | |/ _ \  _ < / _ \| \'_ \ / _` |/ _` | |/ _ \/ __| |  __| / _` | | | |/ _` | __| |/ _ \| \'_ \ ' + "\n" +
      '| |__| |  __/ |_) | (_) | | | | (_| | (_| | |  __/\__ \ | |___| (_| | |_| | (_| | |_| | (_) | | | |' + "\n" +
      '|_____/ \___|____/ \___/|_| |_|\__, |\__, |_|\___||___/ |______\__, |\__,_|\__,_|\__|_|\___/|_| |_|' + "\n" +
      '                                __/ | __/ |                       | |                              ' + "\n" +
      '                               |___/ |___/                        |_|                              '
    @options_msg = [
      "Please select an option:",
      "1. Start with a random board",
      "2. Start with custom board",
      "3. View Highscore",
      "4. Reset Highscore",
      "5. Import new dictionary",
      "6. View help",
      "7. Exit",
      "Enter Option:"
    ]
  
    @options = {
      "1" => -> { random_start },
      "2" => -> { custom_start },
      "3" => -> { view_highscore },
      "4" => -> { reset_highscore },
      "5" => -> { import_dictionary },
      "6" => -> { help },
      "7" => -> { exit_program }
    }

    # Todo: Store the below in json file

    # Todo: Store highscore (perhaps can just load at start? as class level member)
    @highscore = 0

    # Todo: Load dictionary into trie, etc
    @dictionary = DictionaryTrie.new
    puts Dir.pwd
    File.open('./data/dictionary.txt').each { |word| @dictionary.insert(word.chomp.upcase) }
  end

  def start
    begin
      print_formatted @welcome_msg
      while true
        choice = request_input @options_msg.join("\n")

        if is_valid_option?(choice)
          @options[choice].()
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
    # Todo: 1. Clear stored dictionary && dictionary in memory. 2. Load new dictionary into memory and save it on disk
  end

  def help
    help_message = "Todo: create help message"
    print_formatted(help_message)
  end

  def exit_program
    print_formatted "Goodbye! Thanks for playing!"
    handle_shutdown
    # Todo: Remove this sleep and shift it somewhere else
    sleep(5)
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
    print_formatted "Debug: Game with board #{game.get_board_tiles} created"
    game
  end

  def start_playing(game)
    print_formatted "Debug: start_playing run"

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

      #Todo: Refactor by extract method
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
    #Todo: Handle error
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

  def is_valid_option?(option)
    @options.keys.include?(option)
  end

  def print_formatted(message)
    puts "\n#{message}\n"
  end

  def request_input(message)
    print_formatted message
    print '>>> '
    gets.chomp.strip.upcase
  end
end

DeBoggliesEquation.new.start
