# frozen_string_literal: true

class ClassicGame < Game
  CLASSIC_GAME_DURATION = 180
  DESCRIPTION = 'Classic Game, 3 Minutes'
  TYPE = :classic

  def initialize(*args)
    super(*args)
    @duration = CLASSIC_GAME_DURATION
    @description = DESCRIPTION
    @type = TYPE
  end
end
