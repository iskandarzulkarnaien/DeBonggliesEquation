# frozen_string_literal: true

require_relative 'tile.rb'

class Board
  attr_accessor :tiles, :size

  def initialize(size, tile_string)
    @size = size
    @tiles = create_tiles(size, tile_string)
  end

  # TODO: Refactor if possible
  # Linting disabled as this section has been marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  def adjacent_tiles(row, col)
    adj_tiles = []

    if row.positive?
      adj_tiles << tile_at(row - 1, col)
      adj_tiles << tile_at(row - 1, col - 1) unless col.zero?
      adj_tiles << tile_at(row - 1, col + 1) unless col == @size - 1
    end

    adj_tiles << tile_at(row, col - 1) unless col.zero?
    adj_tiles << tile_at(row, col + 1) unless col == @size - 1

    if row < @size - 1
      adj_tiles << tile_at(row + 1, col - 1) unless col.zero?
      adj_tiles << tile_at(row + 1, col)
      adj_tiles << tile_at(row + 1, col + 1) unless col == @size - 1
    end

    adj_tiles
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  def to_s
    tiles.map(&:letter).reduce('') { |string, letter| string + letter }
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
