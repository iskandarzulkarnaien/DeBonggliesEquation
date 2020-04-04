require_relative 'board.rb'
require_relative 'solver.rb'

require 'Set'

class Game
  attr_accessor :duration, :points

  # Standard Boggle Dice Configuration Obtained From:
  # https://boardgames.stackexchange.com/questions/29264/boggle-what-is-the-dice-configuration-for-boggle-in-various-languages
  # Qu replaced with Q, and added * to each dice
  DICE_ZERO =     ['R', 'I', 'F', 'O', 'B', 'X', '*']
  DICE_ONE =      ['I', 'F', 'E', 'H', 'E', 'Y', '*']
  DICE_TWO =      ['D', 'E', 'N', 'O', 'W', 'S', '*']
  DICE_THREE =    ['U', 'T', 'O', 'K', 'N', 'D', '*']
  DICE_FOUR =     ['H', 'M', 'S', 'R', 'A', 'O', '*']
  DICE_FIVE =     ['L', 'U', 'P', 'E', 'T', 'S', '*']
  DICE_SIX =      ['A', 'C', 'I', 'T', 'O', 'A', '*']
  DICE_SEVEN =    ['Y', 'L', 'G', 'K', 'U', 'E', '*']
  DICE_EIGHT =    ['Q', 'B', 'M', 'J', 'O', 'A', '*']
  DICE_NINE =     ['E', 'H', 'I', 'S', 'P', 'N', '*']
  DICE_TEN =      ['V', 'E', 'T', 'I', 'G', 'N', '*']
  DICE_ELEVEN =   ['B', 'A', 'L', 'I', 'Y', 'T', '*']
  DICE_TWELVE =   ['E', 'Z', 'A', 'V', 'N', 'D', '*']
  DICE_THIRTEEN = ['R', 'A', 'L', 'E', 'S', 'C', '*']
  DICE_FOURTEEN = ['U', 'W', 'I', 'L', 'R', 'G', '*']
  DICE_FIFTEEN =  ['P', 'A', 'C', 'E', 'M', 'D', '*']

  ALL_DICE = [
    DICE_ZERO, DICE_ONE, DICE_TWO, DICE_THREE,
    DICE_FOUR, DICE_FIVE, DICE_SIX, DICE_SEVEN,
    DICE_EIGHT, DICE_NINE, DICE_TEN, DICE_ELEVEN,
    DICE_TWELVE, DICE_THIRTEEN, DICE_FOURTEEN, DICE_FIFTEEN
  ]

  BOARD_SIZE = 4

  POINTS_MAPPING = {
    '3' => 1, '4' => 1,
    '5' => 2, '6' => 3, '7' => 5,
    '8' => 11, '9' => 11, '10' => 11, '11' => 11, '12' => 11,
    '13' => 11, '14' => 11, '15' => 11, '16' => 11
  }

  # Todo: Remove debug (or better yet, shift to tests :P)
  DEBUG_BOARD = "TAP*EAKSOBRSS*XD" # Gives words: 585

  def initialize(tiles_string, duration, dictionary)
    @board = tiles_string.nil? ? generate_random_board : Board.new(BOARD_SIZE, tiles_string)
    #Todo: Remove debug
    # @board = Board.new(BOARD_SIZE, DEBUG_BOARD)
    @duration = duration
    @created_at = Time.now
    @points = 0
    @played_words = Set.new
    @valid_words = Solver.new(dictionary, @board).valid_words
    # puts "Debug: is_valid_option?: Num valid words == #{@valid_words.length}"
  end

  def calculate_points(word)
    POINTS_MAPPING["#{word.length}"] if @valid_words.include?(word)
  end

  def increment_points(points)
    @points += points
  end

  def play_word(word)
    @played_words << word
  end

  def is_valid_word?(word)
    @valid_words.include?(word)
  end

  def is_played_word?(word)
    @played_words.include?(word)
  end

  def is_game_over?
    Time.now > (@created_at + @duration)
  end

  def get_time_remaining
    (@created_at + @duration - Time.now).to_i
  end

  def get_board_tiles
    @board.to_s
  end

  def get_board_size
    @board.size
  end

  private

  def generate_random_board
    tiles = []

    chosen_dice = ALL_DICE.sample(BOARD_SIZE * BOARD_SIZE)
    chosen_dice.each { |dice| tiles << dice.sample }

    Board.new(BOARD_SIZE, tiles.shuffle.join)
  end
end
