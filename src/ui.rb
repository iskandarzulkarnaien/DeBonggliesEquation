# frozen_string_literal: true

module Ui
  def self.pause_until_next_user_input(message = 'Press enter to continue...')
    print_formatted message
    gets
  end

  def self.print_formatted(message)
    sleep(0.1) # Instantaenous output is hard to follow and may seem too overwhelming for some users
    puts "\n#{message}\n"
  end

  # TODO: This is coupled with highscore
  def self.formatted_highscore(highscore_tracker)
    "Your Highscores are:\n#{highscore_tracker}"
  end
end
