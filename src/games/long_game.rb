# frozen_string_literal: true

class LongGame < Game
  LONG_GAME_DURATION = 300
  DESCRIPTION = 'Long Game, 5 Minutes'
  TYPE = :long

  def initialize(*args)
    super(*args)
    @duration = LONG_GAME_DURATION
    @description = DESCRIPTION
    @type = TYPE
  end
end
