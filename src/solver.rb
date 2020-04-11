# frozen_string_literal: true

require_relative 'dictionary_trie.rb'

require 'Set'

class Solver
  attr_accessor :valid_words

  MIN_WORD_SIZE = 3

  def initialize(dictionary_trie)
    @dictionary_trie = dictionary_trie
  end

  def solve_boggle(board)
    valid_words = Set.new
    board.tiles.each { |tile| search_trie(valid_words, board, '', tile) }
    valid_words
  end

  def replace_dictionary(dictionary_trie)
    @dictionary_trie = dictionary_trie
  end

  private

  # Linting disabled as this section has been marked for refactor
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def search_trie(valid_words, board, word_fragment, tile, used_tiles = Set.new)
    return if pointless_search?(word_fragment)

    add_if_valid_word(valid_words, word_fragment)

    # TODO: Refactor
    updated_used_tiles = used_tiles.clone
    updated_used_tiles << tile

    board.adjacent_tiles(tile.row, tile.col).each do |adj_tile|
      next if updated_used_tiles.include?(adj_tile)

      current_letter = adj_tile.letter
      if current_letter == '*'
        ('A'..'Z').each do |letter|
          search_trie(valid_words, board, word_fragment + letter, adj_tile, updated_used_tiles)
        end
      else
        search_trie(valid_words, board, word_fragment + current_letter,
                    adj_tile, updated_used_tiles)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def pointless_search?(word_fragment)
    # Early return if non-empty word_fragment is not found in the trie
    !@dictionary_trie.in_trie?(word_fragment) && !word_fragment.empty?
  end

  def add_if_valid_word(valid_words, word_fragment)
    valid_words << word_fragment if valid?(word_fragment)
  end

  def valid?(word_fragment)
    word_fragment.size >= MIN_WORD_SIZE && @dictionary_trie.valid_word?(word_fragment)
  end
end
