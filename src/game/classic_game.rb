class ClassicGame < Game
  CLASSIC_GAME_DURATION = 180
  
  def initialize(tiles_string, dictionary)
    super(tiles_string, dictionary)
    @duration = CLASSIC_GAME_DURATION
    @type = :classic
  end
end