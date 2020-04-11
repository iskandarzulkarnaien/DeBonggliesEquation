# frozen_string_literal: true

class CustomGame < Game
  DESCRIPTION = 'Custom Game Length (Not eligible for highscore!)'
  TYPE = :custom

  def initialize(tiles_string, dictionary, duration)
    super(tiles_string, dictionary)
    @duration = duration
    @description = DESCRIPTION
    @type = TYPE
  end
end
