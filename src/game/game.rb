# frozen_string_literal: true

require_relative '../board.rb'
require_relative '../solver.rb'

require 'Set'

class Game
  attr_accessor :duration, :max_points, :points, :type

  # Standard Boggle Dice Configuration Obtained From:
  # https://boardgames.stackexchange.com/questions/29264/boggle-what-is-the-dice-configuration-for-boggle-in-various-languages
  # Qu replaced with Q, and added * to each dice
  DICE_ZERO =     ['R', 'I', 'F', 'O', 'B', 'X', '*'].freeze
  DICE_ONE =      ['I', 'F', 'E', 'H', 'E', 'Y', '*'].freeze
  DICE_TWO =      ['D', 'E', 'N', 'O', 'W', 'S', '*'].freeze
  DICE_THREE =    ['U', 'T', 'O', 'K', 'N', 'D', '*'].freeze
  DICE_FOUR =     ['H', 'M', 'S', 'R', 'A', 'O', '*'].freeze
  DICE_FIVE =     ['L', 'U', 'P', 'E', 'T', 'S', '*'].freeze
  DICE_SIX =      ['A', 'C', 'I', 'T', 'O', 'A', '*'].freeze
  DICE_SEVEN =    ['Y', 'L', 'G', 'K', 'U', 'E', '*'].freeze
  DICE_EIGHT =    ['Q', 'B', 'M', 'J', 'O', 'A', '*'].freeze
  DICE_NINE =     ['E', 'H', 'I', 'S', 'P', 'N', '*'].freeze
  DICE_TEN =      ['V', 'E', 'T', 'I', 'G', 'N', '*'].freeze
  DICE_ELEVEN =   ['B', 'A', 'L', 'I', 'Y', 'T', '*'].freeze
  DICE_TWELVE =   ['E', 'Z', 'A', 'V', 'N', 'D', '*'].freeze
  DICE_THIRTEEN = ['R', 'A', 'L', 'E', 'S', 'C', '*'].freeze
  DICE_FOURTEEN = ['U', 'W', 'I', 'L', 'R', 'G', '*'].freeze
  DICE_FIFTEEN =  ['P', 'A', 'C', 'E', 'M', 'D', '*'].freeze

  ALL_DICE = [
    DICE_ZERO, DICE_ONE, DICE_TWO, DICE_THREE,
    DICE_FOUR, DICE_FIVE, DICE_SIX, DICE_SEVEN,
    DICE_EIGHT, DICE_NINE, DICE_TEN, DICE_ELEVEN,
    DICE_TWELVE, DICE_THIRTEEN, DICE_FOURTEEN, DICE_FIFTEEN
  ].freeze

  BOARD_SIZE = 4

  POINTS_MAPPING = {
    '3' => 1, '4' => 1,
    '5' => 2, '6' => 3, '7' => 5,
    '8' => 11, '9' => 11, '10' => 11, '11' => 11, '12' => 11,
    '13' => 11, '14' => 11, '15' => 11, '16' => 11
  }.freeze

  # TODO: Remove debug (or better yet, shift to tests :P)
  DEBUG_BOARD = 'TAP*EAKSOBRSS*XD' # Gives words: 585

  GAME_TYPES = %i[short classic long custom sandbox].freeze

  # Not supposed to be instantiated, only for subclasses to use
  def initialize(tiles_string, dictionary)
    @board = tiles_string.nil? ? generate_random_board : Board.new(BOARD_SIZE, tiles_string)
    # TODO: Remove debug
    # @board = Board.new(BOARD_SIZE, DEBUG_BOARD)
    @points = 0
    @played_words = Set.new
    @valid_words = Solver.new(dictionary, @board).valid_words
    @max_points = calculate_max_points

    # Values assigned in subclasses
    @duration = nil
    @type = nil

    # Value assigned on game start
    @start_time = nil
    # puts "Debug: is_valid_option?: Num valid words == #{@valid_words.length}"
  end

  def start
    @start_time = Time.now
  end

  def calculate_points(word)
    POINTS_MAPPING[word.length.to_s] if @valid_words.include?(word)
  end

  def increment_points(points)
    @points += points
  end

  def play_word(word)
    @played_words << word
  end

  def valid_word?(word)
    @valid_words.include?(word)
  end

  def played_word?(word)
    @played_words.include?(word)
  end

  def game_over?
    Time.now > (@start_time + @duration)
  end

  def custom_game?
    @type == :custom
  end

  def time_remaining
    (@start_time + @duration - Time.now).to_i
  end

  def board_tiles
    @board.to_s
  end

  def board_size
    @board.size
  end

  private

  def calculate_max_points
    max_points = 0
    @valid_words.each { |word| max_points += calculate_points(word) }
    max_points
  end

  def generate_random_board
    tiles = []

    chosen_dice = ALL_DICE.sample(BOARD_SIZE * BOARD_SIZE)
    chosen_dice.each { |dice| tiles << dice.sample }

    Board.new(BOARD_SIZE, tiles.shuffle.join)
  end
end
