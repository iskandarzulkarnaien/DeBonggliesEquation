# frozen_string_literal: true

require_relative 'action.rb'

class ViewHelpAction < Action
  MESSAGE = 'View help'
  TYPE = :view_help_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    # TODO: Create help message
    Ui.print_formatted @action_handler.placeholder
    Ui.pause_until_next_user_input
  end
end
