# frozen_string_literal: true

class LongGame < Game
  LONG_GAME_DURATION = 300

  def initialize(*args)
    super(*args)
    @duration = LONG_GAME_DURATION
    @type = :long
  end
end
