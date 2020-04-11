# frozen_string_literal: true

class ClassicGame < Game
  CLASSIC_GAME_DURATION = 180

  def initialize(*args)
    super(*args)
    @duration = CLASSIC_GAME_DURATION
    @type = :classic
  end
end
