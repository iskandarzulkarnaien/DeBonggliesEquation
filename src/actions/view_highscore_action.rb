# frozen_string_literal: true

require_relative 'action.rb'

class ViewHighscoreAction < Action
  MESSAGE = 'View Highscore'
  TYPE = :view_highscore_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    Ui.print_formatted Ui.formatted_highscore(@highscore_tracker)
    Ui.pause_until_next_user_input
  end
end
