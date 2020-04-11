module InputValidator
  def self.valid_duration?(duration)
    # TODO: This looks hacky, find a better way to check if integer
    # Linting suppressed as this line has been marked for refactor
    # rubocop:disable Style/RescueModifier, Lint/RedundantCopDisableDirective
    Integer(duration) rescue false
    # rubocop:enable Style/RescueModifier, Lint/RedundantCopDisableDirective
  end

  def self.valid_integer?(integer)
    # TODO: This looks hacky, find a better way to check if integer
    # Linting suppressed as this line has been marked for refactor
    # rubocop:disable Style/RescueModifier, Lint/RedundantCopDisableDirective
    Integer(integer) rescue false
    # rubocop:enable Style/RescueModifier, Lint/RedundantCopDisableDirective
  end

  def self.valid_board?(board)
    # TODO: Remove hardcoded value
    board.length == 16 && !board.match(/[^A-Z*]/)
  end
end
