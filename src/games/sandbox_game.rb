# frozen_string_literal: true

class SandboxGame < Game
  LONG_GAME_DURATION = 999_999_999_9 # 317 Years

  def initialize(tiles_string, dictionary)
    super(tiles_string, dictionary)
    @duration = LONG_GAME_DURATION
    @type = :sandbox
  end
end
