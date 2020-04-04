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
    @board.tiles.each { |tile|  search_trie('', tile) }
  end

  def search_trie(word_fragment, tile, used_tiles = Set.new)
    return if is_pointless_search(word_fragment) 

    add_if_valid_word(word_fragment)

    # Todo: Refactor
    updated_used_tiles = used_tiles.clone
    updated_used_tiles << tile

    @board.adjacent_tiles(tile.row, tile.col).each do |tile|
      next if updated_used_tiles.include?(tile)
      
      current_letter = tile.letter
      if current_letter == '*'
        ('A'..'Z').each { |letter| search_trie(word_fragment + letter, tile, updated_used_tiles) }
      else
        search_trie(word_fragment + current_letter, tile, updated_used_tiles)
      end
    end
  end

  def is_pointless_search(word_fragment)
    # Early return if non-empty word_fragment is not found in the trie
    !@dictionary_trie.is_in_trie(word_fragment) && !word_fragment.empty?
  end

  def add_if_valid_word(word_fragment)
    @valid_words << word_fragment if is_valid(word_fragment)
  end

  def is_valid(word_fragment)
    word_fragment.size >= MIN_WORD_SIZE && @dictionary_trie.is_valid_word(word_fragment)
  end
end
