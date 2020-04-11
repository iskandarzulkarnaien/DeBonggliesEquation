# frozen_string_literal: true

class Highscore
  attr_accessor :type, :value

  def initialize(symbol, value)
    @type = symbol
    @value = value
  end

  def update_value(value)
    @value = value
  end

  def reset_value
    @value = 0
  end
end
