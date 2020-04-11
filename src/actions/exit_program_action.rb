require_relative 'action.rb'

class ExitProgramAction < Action
  MESSAGE = 'Exit'
  TYPE = :exit_program_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    Ui.print_formatted 'Goodbye! Thanks for playing!'
    @game_manager.handle_shutdown
    # TODO: Remove this sleep and shift it somewhere else
    sleep(3)
    exit
  end
end
