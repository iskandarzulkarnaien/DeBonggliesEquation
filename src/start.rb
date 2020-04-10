#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'debongglies_equation.rb'

require 'bundler/setup'
require 'tk'

puts 'Starting Application...'
puts 'Please stand by...'
DeBoggliesEquation.new.start
