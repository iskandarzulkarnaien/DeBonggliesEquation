# frozen_string_literal: true

class SandboxGame < Game
  LONG_GAME_DURATION = 999_999_999_9 # 317 Years
  DESCRIPTION = 'Sandbox Game, Infinite Duration (Take as long as you like!)'
  TYPE = :sandbox

  def initialize(*args)
    super(*args)
    @duration = LONG_GAME_DURATION
    @description = DESCRIPTION
    @type = TYPE
  end
end
