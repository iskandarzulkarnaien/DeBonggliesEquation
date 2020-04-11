# frozen_string_literal: true

require_relative 'action.rb'

class ResetHighscoreAction < Action
  MESSAGE = 'Reset Highscore'
  TYPE = :reset_highscore_action

  def initialize
    super(MESSAGE, TYPE)
  end

  def execute
    @highscore_tracker.reset_highscore
    Ui.print_formatted 'Your Highscores have all been reset to 0!'
    Ui.pause_until_next_user_input
  end
end
