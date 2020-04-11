# frozen_string_literal: true

class CustomGame < Game
  def initialize(tiles_string, dictionary, duration)
    super(tiles_string, dictionary)
    @duration = duration
    @type = :custom
  end
end
