class SandboxGame < Game
  LONG_GAME_DURATION = 9999999999 # 317 Years
  
  def initialize(tiles_string, dictionary)
    super(tiles_string, dictionary)
    @duration = LONG_GAME_DURATION
    @type = :sandbox
  end
end