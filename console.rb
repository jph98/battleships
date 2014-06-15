#!/usr/bin/env ruby

require_relative "lib/game"

puts "Usage: #{$0} <mode>"

game = Game.new()

puts "\nStarting game..."

while game.not_finished() do

	players = game.get_players()
	players.each do |p|

		puts "\nPlayer #{p.name}'s turn...\n\n"

		# Display the other players board
		p.display_board()
		
		success = false
		
		while not success
			print "\nEnter co-ordinates to attaaackkk: "
			coord = gets.chomp
			unless coord.empty?
				success = p.fire_shot(coord)
			end
		end

		p.display_board()
		
		gets "Press ENTER for the next player"
	end				
end