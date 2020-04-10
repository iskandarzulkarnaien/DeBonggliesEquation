class ShortGame < Game
  SHORT_GAME_DURATION = 120

  def initialize(tiles_string, dictionary)
    super(tiles_string, dictionary)
    @duration = SHORT_GAME_DURATION
    @type = :short
  end
end
