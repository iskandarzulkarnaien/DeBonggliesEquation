# frozen_string_literal: true

require_relative 'action.rb'

class ResetDictionaryAction < Action
  DICTIONARY_PATH = File.join(File.dirname(__FILE__), '../../data/default_dictionary.txt')

  MESSAGE = 'Reset to default dictionary'
  TYPE = :reset_dictionary_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    @game_manager.replace_dictionary(DICTIONARY_PATH)
    Ui.print_formatted 'Default dictionary successfully loaded'
    Ui.pause_until_next_user_input
  end
end
