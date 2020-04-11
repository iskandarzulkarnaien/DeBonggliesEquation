# frozen_string_literal: true

require_relative 'debongglies_equation.rb'

PRE_START_MESSAGES = [
  'Starting Application...',
  'Please stand by...'
].freeze

puts PRE_START_MESSAGES.join("\n")
DeBoggliesEquation.new.start
