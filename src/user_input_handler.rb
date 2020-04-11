# frozen_string_literal: true

module UserInputHandler
  def self.request_input(message)
    Ui.print_formatted message
    print '>>> '
    gets.chomp.strip.upcase
  end

  # TODO: Refactor
  # Linting has been disabled as this section is marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective
  def self.request_game_type(game_handler)
    game_types = game_handler.create_placeholder_games

    game_type_msg = ['Please select a duration option:']
    (1..game_types.size).each do |type_num|
      game_type_msg << "#{type_num}. #{game_types[type_num - 1].description}"
    end
    game_type_msg << 'Enter Option:'

    choice = nil
    loop do
      choice = UserInputHandler.request_input game_type_msg.join("\n")
      break if InputValidator.valid_integer?(choice) && choice.to_i.between?(1, game_types.size)

      Ui.print_formatted 'Invalid duration option selected!'
    end

    game_types[choice.to_i - 1].type
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Lint/RedundantCopDisableDirective

  def self.request_user_board
    user_board = nil
    loop do
      user_board = UserInputHandler.request_input 'Please enter a 16 Letter Board. Valid '\
                                                  'characters are A-Z and *, which can be any '\
                                                  'character'
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
