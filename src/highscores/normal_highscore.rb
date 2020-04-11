# frozen_string_literal: true

class NormalHighscore < Highscore
  def to_s
    "#{@type.capitalize} Games - #{@value} points"
  end
end
