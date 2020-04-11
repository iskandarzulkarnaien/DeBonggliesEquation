require_relative 'random_start_action.rb'
require_relative 'custom_start_action.rb'
require_relative 'view_highscore_action.rb'
require_relative 'reset_highscore_action.rb'
require_relative 'import_dictionary_action.rb'
require_relative 'reset_dictionary_action.rb'
require_relative 'view_help_action.rb'
require_relative 'exit_program_action.rb'

class ActionFactory
  def self.create_all
    [
      RandomStartAction.new,
      CustomStartAction.new,
      ViewHighscoreAction.new,
      ResetHighscoreAction.new,
      ImportDictionaryAction.new,
      ResetDictionaryAction.new,
      ViewHelpAction.new,
      ExitProgramAction.new
    ]
  end
end
