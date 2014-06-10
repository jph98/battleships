#!/usr/bin/env ruby

require_relative "game"

puts "Usage: #{$0} <mode>"

game = Game.new()
game.start()