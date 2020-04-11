# frozen_string_literal: true

class SandboxGame < Game
  LONG_GAME_DURATION = 999_999_999_9 # 317 Years

  def initialize(*args)
    super(*args)
    @duration = LONG_GAME_DURATION
    @type = :sandbox
  end
end
