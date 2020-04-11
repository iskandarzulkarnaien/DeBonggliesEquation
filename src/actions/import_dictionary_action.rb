require_relative 'action.rb'

require 'tk'

class ImportDictionaryAction < Action
  MESSAGE = 'Import new dictionary'
  TYPE = :import_dictionary_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    user_dictionary_path = Tk.getOpenFile('title' => 'Select new dictionary',
                                          'filetypes' => '{{Text} {.txt}}')
    if user_dictionary_path.empty?
      Ui.print_formatted 'Dictionary import cancelled'
    else
      @game_manager.replace_dictionary(user_dictionary_path)
      Ui.print_formatted 'New dictionary successfully loaded'
    end
    Ui.pause_until_next_user_input
  end
end
