# frozen_string_literal: true

require_relative './game/game.rb'
require_relative './highscore/highscore.rb'
require_relative './highscore/normal_highscore.rb'
require_relative './highscore/average_highscore.rb'

class HighscoreTracker
  # TODO: Find a way to remove hardcoded values
  INELIGIBLE_GAMES = [:custom]
  AVERAGED_SCORE_GAMES = [:average]
  NORMAL_GAMES = Game::GAME_TYPES - INELIGIBLE_GAMES - AVERAGED_SCORE_GAMES

  def initialize(args = nil)
    @highscores = args.nil? ? initialize_defaults : load_highscores
  end

  def reset_highscore
    @highscores.each { |highscore| highscore.reset_value }
  end

  def find_highscore(type)
    (@highscores.find { |highscore| highscore.type == type }).value
  end

  def update_highscore(type, value)
    find_highscore(type) = value
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
    AVERAGED_SCORE_GAMES.each { |game_type| highscores << AverageHighscore.new(game_type , 0) }
    highscores
  end

  def load_highscores
    highscores = []
    args.each_pair do |key, value|
      if AVERAGED_SCORE_GAMES.include?(key)
        highscore << AverageHighscore.new(key, value)
      else
        highscore << NormalHighscore.new(key, value)
      end
    end
    highscores
  end

  def stringify
    highscore_msg = []
    @highscores.each { |highscore| highscore_msg << highscore.to_s }
    highscore_msg.join("\n")
  end
end