# frozen_string_literal: true

require_relative 'ui.rb'
require_relative 'user_input_handler.rb'
require_relative 'input_validator.rb'
require_relative 'action_handler.rb'
require_relative 'actions/action_factory.rb'
require_relative 'highscore_tracker.rb'
require_relative 'game_handler.rb'
require_relative 'dictionary_loader.rb'

class DeBoggliesEquation
  include InputValidator
  include Ui

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

  def initialize
    # TODO: Store relevant data (e.g. highscores) in json file
    @highscore_tracker = HighscoreTracker.new
    @game_handler = GameHandler.new(DictionaryLoader.make_dictionary(DICTIONARY_PATH))
    @action_handler = ActionHandler.new

    @all_options = ActionFactory.create_all
    @options_msg = create_options_msg(@all_options)
  end

  # Linting disabled as errors should be caught and passed to handle_error for logging etc
  # rubocop:disable Style/RedundantBegin
  def start
    begin
      Ui.print_formatted WELCOME_MESSAGE
      loop do
        choice = UserInputHandler.request_input @options_msg.join("\n")
        execute_choice(choice)
      end
    rescue StandardError => e
      handle_error(e)
    end
  end
  # rubocop:enable Style/RedundantBegin

  def handle_error(err)
    # TODO: Handle error. Should keep the window open until user presses any input,
    # so the error can be seen instead of window immediately close.
    raise err
  end

  def execute_choice(choice)
    if valid_option?(choice)
      execute_action(choice)
    else
      Ui.print_formatted 'Invalid option selected!'
    end
  end

  def create_options_msg(options)
    options_msg = ['Please select an option:']
    (1..options.size).each do |option_num|
      options_msg << "#{option_num}. #{options[option_num - 1].message}"
    end
    options_msg << 'Enter Option:'
  end

  def execute_action(choice)
    action = @all_options[choice.to_i - 1]
    ActionHandler.execute(action)
  end

  def valid_option?(option)
    return false unless InputValidator.valid_integer?(option)

    option.to_i.between?(1, @all_options.size)
  end
end
