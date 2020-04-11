# frozen_string_literal: true

require_relative '../game/game.rb'

# TODO: Refactor the struct's generation
class Highscore < Struct.new(*Game::GAME_TYPES, :average)
  def initialize(*args)
    return super(*args) unless args.empty?
    reset_highscore
  end

  def to_s
    stringify
  end

  def reset_highscore
    self.members.each { |symbol| self[symbol] = 0 }
  end

  private

  # TODO: Refactor
  def stringify
    highscore_msg = []
    self.each_pair do |type, value|
      highscore_msg << "#{type.capitalize} Games - #{value} points" unless type == :average
    end
    highscore_msg << "Average highscore - #{self[:average]} points/second"
    highscore_msg.join("\n")
  end
end