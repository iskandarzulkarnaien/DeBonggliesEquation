# frozen_string_literal: true

require_relative 'short_game.rb'
require_relative 'classic_game.rb'
require_relative 'long_game.rb'
require_relative 'sandbox_game.rb'
require_relative 'custom_game.rb'

class GameFactory
  def self.create_preset_game(tiles_string, solver, type)
    case type
    when :short
      ShortGame.new(tiles_string, solver)
    when :classic
      ClassicGame.new(tiles_string, solver)
    when :long
      LongGame.new(tiles_string, solver)
    when :sandbox
      SandboxGame.new(tiles_string, solver)
    end
  end

  def self.create_custom_game(tiles_string, solver, duration)
    CustomGame.new(tiles_string, solver, duration)
  end
end
