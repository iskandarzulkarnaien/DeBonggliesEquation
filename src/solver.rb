# frozen_string_literal: true

require_relative 'dictionary_trie.rb'

require 'Set'

class Solver
  attr_accessor :valid_words

  MIN_WORD_SIZE = 3

  def initialize(dictionary_trie, board)
    @dictionary_trie = dictionary_trie
    @board = board
    @valid_words = Set.new
    solve_boggle
  end

  private

  def solve_boggle
    @board.tiles.each { |tile| search_trie('', tile) }
  end

  # Linting disabled as this section has been marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def search_trie(word_fragment, tile, used_tiles = Set.new)
    return if pointless_search?(word_fragment)

    add_if_valid_word(word_fragment)

    # TODO: Refactor
    updated_used_tiles = used_tiles.clone
    updated_used_tiles << tile

    @board.adjacent_tiles(tile.row, tile.col).each do |adj_tile|
      next if updated_used_tiles.include?(adj_tile)

      current_letter = adj_tile.letter
      if current_letter == '*'
        ('A'..'Z').each do |letter|
          search_trie(word_fragment + letter, adj_tile, updated_used_tiles)
        end
      else
        search_trie(word_fragment + current_letter, adj_tile, updated_used_tiles)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def pointless_search?(word_fragment)
    # Early return if non-empty word_fragment is not found in the trie
    !@dictionary_trie.in_trie?(word_fragment) && !word_fragment.empty?
  end

  def add_if_valid_word(word_fragment)
    @valid_words << word_fragment if valid?(word_fragment)
  end

  def valid?(word_fragment)
    word_fragment.size >= MIN_WORD_SIZE && @dictionary_trie.valid_word?(word_fragment)
  end
end
