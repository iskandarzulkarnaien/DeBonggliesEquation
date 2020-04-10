class LongGame < Game
  LONG_GAME_DURATION = 300
  
  def initialize(tiles_string, dictionary)
    super(tiles_string, dictionary)
    @duration = LONG_GAME_DURATION
    @type = :long
  end
end