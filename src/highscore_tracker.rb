# frozen_string_literal: true

require_relative './games/game.rb'
require_relative './highscores/highscore.rb'
require_relative './highscores/normal_highscore.rb'
require_relative './highscores/average_highscore.rb'

# TODO: Proper singleton pattern
class HighscoreTracker
  # TODO: Find a way to remove hardcoded values
  INELIGIBLE_GAMES = [:custom].freeze
  AVERAGED_SCORE_GAMES = [:average].freeze
  NORMAL_GAMES = (Game::GAME_TYPES - INELIGIBLE_GAMES - AVERAGED_SCORE_GAMES).freeze

  @current_highscore_tracker = nil

  def initialize(args = nil)
    @highscores = args.nil? ? initialize_defaults : load_highscores
    @current_highscore_tracker = self
  end

  def self.current
    @current_highscore_tracker || new
  end

  def reset_highscore
    @highscores.each(&:reset_value)
  end

  def find_highscore(type)
    find_item(type).value
  end

  def update_highscore(type, value)
    find_item(type).update_value(value)
  end

  def eligible_for_update?(type, value)
    !INELIGIBLE_GAMES.include?(type) && value > find_highscore(type)
  end

  def to_s
    stringify
  end

  private

  def initialize_defaults
    highscores = []
    NORMAL_GAMES.each { |game_type| highscores << NormalHighscore.new(game_type, 0) }
    AVERAGED_SCORE_GAMES.each { |game_type| highscores << AverageHighscore.new(game_type, 0) }
    highscores
  end

  def load_highscores
    highscores = []
    args.each_pair do |key, value|
      highscore <<
        if AVERAGED_SCORE_GAMES.include?(key)
          AverageHighscore.new(key, value)
        else
          NormalHighscore.new(key, value)
        end
    end
    highscores
  end

  def find_item(type)
    @highscores.find { |highscore| highscore.type == type }
  end

  def stringify
    highscore_msg = []
    @highscores.each { |highscore| highscore_msg << highscore.to_s }
    highscore_msg.join("\n")
  end
end
