module UserInputHandler
  def self.request_input(message)
    Ui.print_formatted message
    print '>>> '
    gets.chomp.strip.upcase
  end
  # TODO: Refactor
  # Linting has been disabled as this section is marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective
  def self.request_game_type
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
      choice = UserInputHandler.request_input game_type_msg.join("\n")
      break if game_types.keys.include?(choice)

      Ui.print_formatted 'Invalid duration option selected!'
    end

    game_types[choice][:type]
  end

  def self.request_user_board
    user_board = nil
    loop do
      user_board = UserInputHandler.request_input  'Please enter a 16 Letter Board. Valid characters are A-Z and *,'\
                                  'which can be any character'
      break if InputValidator.valid_board?(user_board)

      Ui.print_formatted 'Your board contains invalid characters!'
    end
    user_board
  end

  def self.request_duration
    duration = nil
    loop do
      duration = UserInputHandler.request_input 'Please enter the game\'s duration, in seconds'
      break if InputValidator.valid_duration?(duration)

      Ui.print_formatted 'Your duration is invalid!'
    end

    duration.to_i
  end
end
