# frozen_string_literal: true

class AverageHighscore < Highscore
  def initialize(*args)
    super(*args)
    @divisor = "second" # TODO: Refactor hardcoded value
  end

  def to_s
    "#{@type.capitalize} Games - #{@value} points/#{@divisor}"
  end
end