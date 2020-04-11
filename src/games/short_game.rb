# frozen_string_literal: true

class ShortGame < Game
  SHORT_GAME_DURATION = 120
  DESCRIPTION = 'Short Game, 2 Minutes'
  TYPE = :short

  def initialize(*args)
    super(*args)
    @duration = SHORT_GAME_DURATION
    @description = DESCRIPTION
    @type = TYPE
  end
end
