# frozen_string_literal: true

class Tile
  attr_accessor :letter, :row, :col

  def initialize(letter, row, col)
    @letter = letter
    @row = row
    @col = col
  end
end
