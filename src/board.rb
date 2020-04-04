require_relative 'tile.rb'

class Board
  attr_accessor :tiles

  def initialize(size, tile_string)
    @size = size
    @tiles = create_tiles(size, tile_string)
  end

  # Todo: Refactor if possible
  def adjacent_tiles(row, col)
    adj_tiles = []

    if row > 0
      adj_tiles << tile_at(row - 1, col)
      adj_tiles << tile_at(row - 1, col - 1) unless col == 0
      adj_tiles << tile_at(row - 1, col + 1) unless col == @size - 1
    end

    adj_tiles << tile_at(row, col - 1) unless col == 0
    adj_tiles << tile_at(row, col + 1) unless col == @size - 1

    if row < @size - 1
      adj_tiles<< tile_at(row + 1, col - 1) unless col == 0
      adj_tiles << tile_at(row + 1, col)
      adj_tiles << tile_at(row + 1, col + 1) unless col == @size - 1
    end

    adj_tiles
  end

  def to_s
    (tiles.map { |tile| tile.letter }).reduce('') { |string, letter| string + letter }
    
  end

  private

  def create_tiles(size, tile_string)
    tiles = []
    size.times do |row|
      size.times do |col|
        letter = tile_string[row * size + col]
        tiles << Tile.new(letter, row, col)
      end
    end
    tiles
  end

  def tile_at(row, col)
    @tiles[row * @size + col]
  end
end
