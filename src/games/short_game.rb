# frozen_string_literal: true

class ShortGame < Game
  SHORT_GAME_DURATION = 120

  def initialize(*args)
    super(*args)
    @duration = SHORT_GAME_DURATION
    @type = :short
  end
end
